import { Page, Content, InfoCard, TabbedCard, CardTab, CodeSnippet } from '@backstage/core-components';
import { HomePageCompanyLogo, TemplateBackstageLogo, HomePageToolkit, TemplateBackstageLogoIcon } from '@backstage/plugin-home';
import { SearchContextProvider } from '@backstage/plugin-search-react';
import { HomePageSearchBar } from '@backstage/plugin-search';
import { Grid } from '@material-ui/core';
import React from 'react';
import { Link } from '@backstage/core-components';
import { ArgoCdIcon, ElasticSearchIcon, TeamEmailIcon, TeamIcon } from './CustomIcons'
import workflowImage from './developer-workflow.jpg';

import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ( {
  searchBar: {
    color: theme.palette.text.primary,
    padding: theme.spacing(1, 2),
    maxWidth: '60vw',
    
  },
  searchBarOutline: {
    borderColor: theme.palette.divider,
    borderRadius: 50,
    boxShadow: '0px 2px 1px -1px rgba(0, 0, 0, 0.2), 0px 1px 1px 0px rgba(0, 0, 0, 0.14), 0px 1px 3px 0px rgba(0, 0, 0, 0.12)',
  },
  highlight: {
    color: '#32CD32',
    fontWeight: 'bold',
  },
  img: {
      maxWidth: '100%',
      height: 'auto',
      borderRadius: '28px',
      boxShadow: '2px 2px 10px rgba(0, 0, 0, 0.1)',
  },
}));

const useLogoStyles = makeStyles((theme) => ({
  svg: {
    width: 250,
    height: 100,
  },
  path: {
    stroke: '#7df3e1',
    strokeWidth: 6,
  },
  container: {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
  },
}));

export { useStyles, useLogoStyles };

export const HomePage = () => {
  const classes = useStyles();
  const {
    svg,
    path,
    container
  } = useLogoStyles();
  return <SearchContextProvider>
      <Page themeId="home">
        <Content>
          <Grid container justifyContent="center" spacing={6}>
            <HomePageCompanyLogo className={container} logo={<TemplateBackstageLogo classes={{
              svg,
              path
            }} />} />

            <Grid container item xs={12} alignItems="center" direction="row" justifyContent="center">
              <header style={{ textAlign: 'center' }}>
                <h1>Welcome to the Internal Developer Platform</h1>
                <p>Your platform for spinning up services and owning your infrastructure — all in one place</p>
              </header>
            </Grid>

            <Grid container item xs={12} alignItems="center" direction="row" justifyContent="center">
              <HomePageSearchBar classes={{
              root: classes.searchBar
              }} InputProps={{
                    classes: {
                      notchedOutline: classes.searchBarOutline
                    }
                  }} placeholder="Search" />
            </Grid>

            
            <Grid container item xs={12}>
              <Grid container spacing={2} alignItems="stretch">            
                <Grid item xs={12} md={9}>
                  <InfoCard title="Getting started">
                    <div>
                      <p>Our platform is your key to a seamless, efficient, and modern software development experience. Try it out and see how much smoother your workflow can be! 🚀</p>
                      <p>To start using the platform, explore our guidelines and documentation. Currently, this platform is being populated with essential resources and tools for developers. Stay tuned for updates!</p>
                    </div> 
                  </InfoCard>
                </Grid>
                <Grid item xs={12} md={3}>
                  <InfoCard title="Quick access">
                    <ul>
                      <li style={{ marginBottom: 10}}><Link to="/catalog/default/component/backstage">Overall documentation and information</Link></li>
                      <li style={{ marginBottom: 10}}><Link to="/catalog/default/component/how-to-use-wms-server-config-template">How to use WMS Server config template</Link></li>
                      <li style={{ marginBottom: 10}}><Link to="/create/templates/default/create-wms-server-config">Create WMS Server config</Link></li>
                    </ul>
                  </InfoCard>
                </Grid>

                <Grid item xs={12} md={9} style={{ display: 'flex' }}>
                  <TabbedCard title="Internal Developer Platform">
                    <CardTab label="Overview of IDP">
                      <div>                    
                        <p>
                          An Internal Developer Platform (IDP) is a central <a href="https://en.wikipedia.org/wiki/Computing_platform">platform </a>
                          that enables developers to access the tools, resources, and environments they need to build, test, and deploy
                          applications efficiently. Our IDP is designed to provide a unified and simplified experience, streamlining
                          workflows and enhancing collaboration across teams.
                        </p>
                      </div>
                    </CardTab>
                    <CardTab label="Product vision">
                      <div>
                        <p>
                          We envision an environment where software development cycles are fast, reliable, and scalable, 
                          supported by a culture of experimentation, continuous improvement, and a streamlined developer experience.
                        </p>
                        <p>
                            To achieve this, we intend to build an internal development platform (IDP) that serves as a centralized, 
                            self-service interface for developers, enabling them to focus on delivering value without the burden of 
                            operational complexity. This platform will unify tools, processes, and best practices, creating a streamlined 
                            and highly efficient development workflow.
                        </p>
                        <p>
                          An IDP will improve operations by:
                        </p>
                        <ol>
                            <li>
                                <strong>Accelerating Development Cycles</strong><br></br>
                                By providing on-demand environments, reusable templates, and pre-configured resources, the platform will 
                                eliminate repetitive tasks, reduce setup time, and enable rapid iteration from idea to deployment.
                            </li>
                            <li>
                                <strong>Promoting Automation and Reproducibility</strong><br></br>
                                The IDP will emphasize automation, reducing the risk of human error and increasing consistency. Automated 
                                CI/CD pipelines, infrastructure-as-code templates, and self-healing mechanisms will ensure scalability and 
                                reliability.
                            </li>
                            <li>
                                <strong>Driving Innovation through Experimentation</strong><br></br>
                                By enabling easy provisioning of isolated environments, the platform will allow developers to test ideas safely 
                                and quickly.
                            </li>
                            <li>
                                <strong>Supporting Continuous Improvement</strong><br></br>
                                Usage insights and feedback will drive the platform's evolution to meet developers' and organizational needs. 
                                Metrics and KPIs will help identify bottlenecks and areas for refinement.
                            </li>
                            <li>
                                <strong>Ensuring scalability</strong><br></br>
                                Through a scalable platform that can grow with the organization, enabling rapid deployment of new teams and ensuring 
                                that all teams have access to the same tools and services.
                            </li>
                        </ol>
                          <p>
                              By aligning with the right principles and focusing on the developer experience, this platform will become the foundation 
                              of technological excellence for our organization. It will not only increase operational efficiency and reliability but also 
                              cultivate a culture of experimentation, innovation, and satisfaction-enthusing both customers and employees.
                          </p>
                      </div>
                    </CardTab>
                    <CardTab label="Key benefits">
                      <div>
                        <p>
                          Our Internal Developer Platform (IDP) makes software development faster, more efficient, and hassle-free.
                          Instead of dealing with infrastructure, permissions, or manual workflows, you can focus on what truly matters:
                          <strong>writing code and delivering value.</strong>
                        </p>
                        <ul>
                          <li><strong>✅ Fast Provisioning</strong> – Launch new projects and deploy services in minutes instead of hours or days.</li>
                          <li><strong>✅ Reduced Operational Overhead</strong> – No manual infrastructure setup, no unnecessary waiting times.</li>
                          <li><strong>✅ Standardized Best Practices</strong> – Unified processes ensure stability, security, and efficiency.</li>
                          <li><strong>✅ Transparency &amp; Traceability</strong> – Always have full visibility into your services and their status.</li>
                          <li><strong>✅ Self-Service &amp; Autonomy</strong> – Develop independently without relying on other teams or waiting for approvals.</li>
                          <li><strong>✅ Scalability &amp; Future-Proofing</strong> – The platform grows with your needs without additional management overhead.</li>
                        </ul>
                      </div>
                    </CardTab>
                    <CardTab label="Example of use">
                      <div>
                        <p>
                          Imagine you can create a WMS server on the Google Cloud Platform with a few clicks on our frontend, or a few lines of code, like in this imaginary example:
                        </p>
                      </div>
                      <CodeSnippet text={'apiVersion: wms.log.psi.de/v1alpha1 \nkind: WmsServerHost \nmetadata: \n  name: wms-server-host-test \nspec: \n  size: small \n  enableSsh: true'} language="python" />
                      <div>
                        <p>This is a YAML configuration file. Specifically, it appears to be a custom resource definition (CRD) for a Kubernetes-like system, used to define a "WmsServerHost" instance. Below, we break it down step by step.</p>
                        <p><span className={classes.highlight}>apiVersion</span>: Specifies the version of the API handling this resource.</p>
                        <p><span className={classes.highlight}>kind</span>: Declares that this resource is a <em>WmsServerHost</em>, which is likely a virtual machine.</p>
                        <p><span className={classes.highlight}>metadata</span>: Provides a unique name for this resource</p>
                        <p><span className={classes.highlight}>spec</span>: Contains configuration details</p>
                        <p><span className={classes.highlight}>size: small</span> → The server is a small instance, likely with limited CPU and memory.</p>
                        <p><span className={classes.highlight}>enableSsh: true</span> → SSH access is enabled, allowing remote login.</p>

                        <p>This setup provisions a VM in Google Cloud along with an <a href="https://cloud.google.com/load-balancing/docs/l7-internal?hl=en#regional">internal load balancer</a>. 
                          The seamless operation of the actual VM is implemented centrally, so you don't have to care about all the underlying components, like Instance Templates, Managed Instance Groups, 
                          Backend Services, URL Maps, Target HTTP(S) Proxies, Forwarding Rules, and more.
                        </p>
                      </div>
                    </CardTab>
                  </TabbedCard>         
                </Grid>

                <Grid item xs={12} md={3}>
                  <HomePageToolkit tools={[{
                    url: 'https://argocd.alfheim.internal.psicloud.de/',
                    label: 'ArgoCD',
                    icon: <ArgoCdIcon/>
                    }, 
                    {
                      url: 'http://elasticsearch.log.dev.gcp.psi.de/',
                      label: 'Elastic \nSearch',
                      icon: <ElasticSearchIcon />
                    },
                    {
                      url: '#',
                      label: 'New service soon...',
                      icon: <TemplateBackstageLogoIcon />
                    }]} />
                </Grid>
                <Grid item xs={12} md={9}>
                  <InfoCard title="Developer workflow with GitOps and IDP">
                    <div>
                      <img className={classes.img} src={workflowImage} alt="Infrastructure Automation Diagram"></img>
                      <p>Developers have two ways to create the configuration file:</p>
                      <ul>
                          <li><strong>Manual Creation</strong> - Writing the file themselves.</li>
                          <li><strong>Automated Generation</strong> - Using our frontend to create it effortlessly.</li>
                      </ul>
                      <p>
                          Regardless of the method, the configuration file is stored in the
                          <strong>same Git repository</strong> where developers manage their code — not a separate system.
                          Git tracks changes to the file just like any other project asset.
                      </p>
                      <p>
                          Once the file is in place, our system continuously monitors the repository. Any updates trigger
                          an automated process that <strong>provisions, updates, or removes infrastructure as needed-
                          without manual intervention.</strong>
                      </p>
                    </div>
                  </InfoCard>
                </Grid>
                <Grid item xs={12} md={3}>
                  <InfoCard title="Support" subheader="If you have any questions or need help, please contact us">
                  <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
                    <TeamIcon />
                    <p>LOG IDP Team</p>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
                    <TeamEmailIcon />
                    <a href="mailto:idp-team@psi.de" >idp-team@psi.de</a>
                  </div>
                  </InfoCard>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </Content>
      </Page>
    </SearchContextProvider>;
}
