from typing import overload

from flask import Flask, render_template, request, redirect, url_for, jsonify, Response, flash

app = Flask(__name__)

# In-memory data storage for demonstration purposes
kubernetes_clusters = []
vms = []


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/kubernetes')
def kubernetes():
    return render_template('kubernetes.html', clusters=kubernetes_clusters)


@app.route('/kubernetes/new', methods=['POST', 'GET'])
def kubernetes_new():
    if request.method == 'POST':
        data = request.form
        status = 'running' if len(data['name']) % 2 == 0 else 'down'
        kubernetes_clusters.append({'name': data['name'], 'status': status})
        return redirect(url_for('kubernetes', code=303))
    return render_template('create_kubernetes.html')


@app.route('/kubernetes/<int:cluster_id>', methods=['GET', 'DELETE'])
def kubernetes_cluster(cluster_id):
    kubeconfig = '''
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://prod.example.com
  name: prod-cluster
contexts:
- context:
    cluster: prod-cluster
    namespace: prod-namespace
    user: prod-user
  name: my-context
current-context: my-context
users:
- name: prod-user
  user:
    token: REDACTED
    '''
    if request.method == 'DELETE':
        del kubernetes_clusters[cluster_id]
        return redirect(url_for('kubernetes'), code=303)
    return render_template('kubernetes_details.html', cluster=kubernetes_clusters[cluster_id], kubeconfig=kubeconfig)


@app.route('/vm')
def vm():
    return render_template('vm.html', vms=vms)


@app.route('/create_vm', methods=['GET', 'POST'])
def create_vm():
    return render_template('create_vm.html')


if __name__ == '__main__':
    app.run(debug=True)
