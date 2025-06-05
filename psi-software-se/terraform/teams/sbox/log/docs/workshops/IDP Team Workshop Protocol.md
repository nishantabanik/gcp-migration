# **Protocol of the team workshops conducted in December 2024**

# Product related topics
Visioning the alternate future of _Internal Developer Platform_ being developed and identifying relevant metrics.  
## Opportunities and risks 
#### Questions asked
##### Potential offerings
The participants were answering following questions: "What capabilities does the platform offer in each of the five areas that made it so successful? What makes the user love the platform so much?"
##### Risks and failure modes
The participants were answering following question: "What have we done (or failed to do) that turned this once-promising idea into an utter flop?"
### Accelerating Development Cycles
#### Potential offerings
- being faster on deployment
- much faster, easier, more stable and immutable artifact delivery
- faster delivering to market
- less error prone
- less manual work causes less annoying errors
- no need of "secret" knowledge how to build an application because of pipeline definition available
- no manual changes in TST, INT or PROD environments needed / allowed
- all development teams use CI by integrating our provisioned pipeline
- less time needed for applying change and testing it
- faster feedback
- having an easy way to set up environments even for non IT-people
- templates via _Backstage_ with drop down menu
- a way for the users to store their templates if they use them often
- view code, metrics, logs, status (monitoring) etc. via (centralized) WebUI
#### Risks and failure modes
- IDP usage imposes overhead
- our process is not better than the old one
- processes are too complicated or take too much time
- development teams do not see the need to build quicker
### Providing Automation and Reproducibility
#### Potential offerings
- promote services that are available but teams are not using them because they are not aware of it 
- provide templates 
	- flexible processes for project teams
- easy way to implement Continuous Deployment
- enable teams to support multiple versions of different "products"
- usage of preconfigured pipelines, tools leads to less errors
- provide standardized and automated processes
- less issues on deployment due to CD based on our template
- no more pushes to main directly
- no SVN (_appeared x 3 on the board_)
	- provided easy way to migrate
	- pressured to move (_shouldn't it be incentivized_?)
	- what are ways that we can make it easy for the users?
#### Risks and failure modes
- templates are not flexible enough and hard to use for most of the teams
- templates are not usable by everyone
- using IDP requires a lot of manual steps
- too much need of manual customizations of templates
- keep SVN
- teams do not change their behavior
- the don't want to switch to services we provide and we don't want to provide their "old" services
### Driving Innovation through Experimentation
#### Potential offerings
- are not afraid of making mistakes
- easy way to set up sandboxes made it fun to experiment and integrate
- provide safe and easily accessible environments for experiments and testing new things
- make developers get in touch with "new" technologies
- change developers mindsets to learn new things because there is less pressure/stress in project/product development
- deliver new technologies that can be tested
- no only new features, also new knowledge
- no Excel for any configurations
- copy the whole prod. environment to a test environment to test changes
#### Risks and failure modes
- need Excel with plugins to configure our product
- having similar approach as the teams
- development teams do not want responsibility for operating their services
### Supporting Continuous Improvement
#### Potential offerings
- all teams can easily add new services by themselves
- platform tailored for the teams due to quick iteration and good feedback
- using templates ensured security and decoupled teams from security team
- enables teams to work with "real" and efficient agile methods (because the platform enables them to do so)
- automated metrics and testing/monitoring of code (quality) and running software
- easy way to get feedback
- user knows where to give feedback easily
- also the get fast responses from us and what we plan to change and when
- making teams aware of the cost the long running builds are causing incentivizing them to improve
#### Risks and failure modes
- working on the wrong things
	- services are too generic and are not fixing any specific issues
	- don't listen to users and do not give them feedback
- no easy way to customize services
- changing too slow to adjust dev teams' needs
- let top, non-technical (or once-long-time-ago-technical) people dictate our scope of work
- divert from our vision because of decisions from the outside
### Ensuring scalability
#### Potential offerings
- each teams are able and know how to add service to the platform by themself in automated way
- easy to provision new services with more power
- having unlimited "resources" like CPU, RAM, storage, money?
- automate infrastructure (via code)
	- DNS
	- storage
	- IP Addresses (IPv6)
- auto-scaling 
- containerization
- no dependencies between the teams
- refuse to do some work for others like "operation", instead provide a service so they can do it themselves easily
#### Risks and failure modes
- the costs will go too high and we will go bankrupt 
- out of RAM error - virtual machines / containers crashing all the time
- dependency on Central Development platform that prevents us from innovating
- get distracted from working on the IDP by toil work that should be made easy byt the IDP
- dev teams expect us to set up stuff for them
### Common issues / General failures
- focus on the wrong services and templates
- not listening or understanding stakeholder needs (PJF case)
- too complicated to use
- teams reject to use it because they don't know how or why to use it
- no urge for developers to change old well known practices to learn something new
- not independent from us
- neglect IDP adoption
- drown in bureaucracy
- no diversity among stakeholders for getting feedback (focusing on one)
- lack of some capabilities to run an IDP
- no change in technologies (Linux tools outdated since 1997)
### Prioritized top areas with greatest impact on success
- identification of the right stakeholders that will be interested in IDP
- IDP should be easy to use (easier than the current stuff)
- easy to use templates and configurable
- we don't want to become bottleneck (introducing unwanted dependencies on us)
- onboarding and marketing (awareness and adoption strategy)
## Measures of success
Potential measures of success were explored and selected to work with in two areas: **Software delivery performance** and **Product related**. 
Checked ones were selected to experiment with.
### Software Delivery Performance
- [ ] Development Cycle Time (including time before pushing and merging)
- [x] Story Points planned vs done in a sprint
- Throughput/Velocity:
	- [-] Time until a commit is visible at the customer site (Change Lead Time)
	- [-] How often do we deploy (Deployment Frequency)
- Stability:
	- [-] Percentage of changes that result in problems (Change Fail Percentage)
	- [-] How long does it take to recover from breakage (Time To Restore Service)
### Product related
- [-] Service / feature usage
- [ ] number of active users per week
- [ ] number of users
- [ ] number of people in review
- [-] cost of the infrastructure
- [ ] positive/negative feedback
### Open topics to be addressed about the selected measures
- How will we measure them?
- How will we be collecting the data?
- How will we incorporate the metrics in our planning activities? (logs-, mid- and short-term) 
# Team related topics
Fostering safe environment for collaboration aligning on mutual expectations.
## Psychological safety
### What makes me feel safe to share ideas, opinions or concerns in a team?
- working remote, nobody can punch me in the face
- getting both positive and negative feedback
- equivalence 
- knowing that others are open for solid reasoning
- realizing and actively thinking that people are not jerks
- well established knowledge on a topic
- knowing the team members in person
- trusting people you work with
- the team itself - awesome team!
- positive attitude of other team members
- openness to new opinions on ideas 
- knowing that others are open for criticism
- the team is generally open to discussions and other ideas (sometimes)
### What makes it harder for me to speak up or feel comfortable?
- expectation of a lot of opposition with no supporting opinion
- lack of sleep 
- language barrier (x3)
- lack of knowledge on the topic being discussed (x3)
- not being listened to
- being constantly interrupted
- being criticized in front of people I do not know / trust
- the feeling / impression of overruling others' opinions
- HIPPO (Highest Paid Person's Opinion) wins discussion
- political discussions
- Bluetooth technology (technical issues)
- when I thinks that a decision has already been made because of some strong opinions in the team
- environment where mentioning a problem leads to being responsible for it
- critic that is not factual
- when it is about winning 
- when I get overloaded with lots of arguments
### What can others do to help me feel more supported?
- ask me directly for my opinion
- acknowledge valid arguments and criticism
- discussion with room for feedback
- ask more questions about problematic topics
- applause if I complete a ticket would be nice (joke)
- more hugs (joke)
- constructive criticism
- accept I might not know
- openly express ideas that oppose mine
- express curiosity of what I am saying
- trying to really understand what was meant
- pair programming
## Mutual expectations

| What ⬇️ expect from ➡️ | Developers                                                                                                                                                                                                                                                                                                                                                                                                                        | Product Owner                                                                                                                                                                                                                                                     | Scrum Master                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Developers**         | - share knowledge (1)<br>- do tasks<br>- work, work<br>- collaborate with other developers (6)<br>- good documentation<br>- clean code<br>- more learning on topics we don't know - like TF (2)<br>- discuss implementation details<br>- implementing features<br>- help each other                                                                                                                                               | - prepare refinement or let be prepared (5)<br>- stakeholder management (4)<br>- create backlog items, set priority for them<br>- know the backlog<br>- point us in the right direction<br>- express clear product vision (1)<br>- propose realistic sprint goals | - keep people away (1)<br>- live the _Scrum Guide_ (4)<br>- help with meetings related to sprint<br>- encourage team members to collaborate (1)<br>- help the team members to help themselves (1)                                                                                                                                                                                                                          |
| **Product Owner**      | - take responsibility for our processes (4)<br>- make availability transparent to the team<br>- usually be on the Daily, Refinement and Planning<br>- take responsibility for code / repo quality (5)<br>- make and effort to split tickets (4) <br>- evolve team agreements<br>- stick to team agreements like the DoD<br>- use the "tools" needed to get the job done<br>- participate in Planning / Refinement discussions (1) | - preparation of Refinement and Planning<br>- have a DEEP Product Backlog (6)<br>- regularly refine the Product Backlog (next 2-4 sprints)                                                                                                                        | - explain to others how our team works<br>- help us figure out the "Story Points Issue" (6)<br>- help increasing team engagement (4)                                                                                                                                                                                                                                                                                       |
| **Scrum Master**       | - consider quality part of their craftsmanship (1)<br>- invent solutions to the problems stated in the Product Backlog Items<br>- live the DoD<br>- hold each other accountable for commitments<br>- share the responsibility for the code (2)                                                                                                                                                                                    | - keep the backlog in state that reflects the product decisions<br>- engage with the stakeholders to understand their needs<br>- clearly express the goals for the product (5)<br>- engage the team in problem solving (1)                                        | - rise the topics the team can not solve themselves to the awareness of the management<br>- helo the team identify impediments and help them solve these<br>- propose formats to enhance collaboration on the meetings (1)<br>- help the team get outcomes and goals of the meetings (3)<br>- answer questions about _Scrum_ and agility<br>- helping the team reflect on the ways of improving their internal process (1) |
# 