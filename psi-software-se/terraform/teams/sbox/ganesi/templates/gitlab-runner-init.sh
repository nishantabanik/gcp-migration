#! /bin/bash
set -ex
function initialize() {
    mkfs.ext4 -L data1 /dev/sdb
    echo "LABEL=data1 /mnt/data1 ext4 defaults 0 2" >> /etc/fstab
    mkdir -p /mnt/data1
    zypper install -y docker docker-compose docker-compose-switch
    mkdir -p /mnt/data1
    mount -a
    systemctl enable docker
    systemctl restart docker
    curl -o /tmp/gitlab-runner-helper-images.rpm -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/rpm/gitlab-runner-helper-images.rpm"
    curl -o /tmp/gitlab-runner_amd64.rpm -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/rpm/gitlab-runner_amd64.rpm"
    zypper --no-gpg-checks install -y /tmp/gitlab-runner-helper-images.rpm
    zypper --no-gpg-checks install -y /tmp/gitlab-runner_amd64.rpm
    echo '[Unit]
    Description=GitLab Runner
    After=network.target

    [Service]
    ExecStart=/usr/bin/gitlab-runner run --config /home/gitlab-runner/.gitlab-runner/config.toml
    Restart=always
    User=gitlab-runner
    Environment="PATH=/usr/bin:/usr/local/bin"
    WorkingDirectory=/home/gitlab-runner

    [Install]
    WantedBy=multi-user.target' > /etc/systemd/system/gitlab-runner.service
    systemctl enable gitlab-runner
    touch /initialized
}

if [[ ! -f "/initialized" ]]; then
    echo "System is unintialized! Initializing now."
    initialize
else
    echo "System is already initialized!"
fi

mount -a

RUNNER_TOKEN=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/RUNNER_TOKEN -H "Metadata-Flavor: Google")
su - gitlab-runner -c "gitlab-runner register --non-interactive --url \"https://gitlab.com/\" --token \"$RUNNER_TOKEN\" --executor \"docker\" --docker-image google/cloud-sdk --description \"vm-gitlab-runner\""
sed -i '/^\s*volumes = \[/ s/]$/,"\/mnt\/data1:\/builds", "\/var\/run\/docker.sock:\/var\/run\/docker.sock"]/' /home/gitlab-runner/.gitlab-runner/config.toml
usermod -aG docker gitlab-runner
newgrp docker
systemctl daemon-reexec
systemctl daemon-reload
systemctl start gitlab-runner