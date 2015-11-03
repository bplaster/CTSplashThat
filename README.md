# README #

Squad

<img src="http://bplaster.github.io/CTSplashThat/mock.png" width="600px">

Handling unexpected “fires” during an event can often throw an entire event into freefall. What adds to the difficulty in resolving these issues is the complications of discovering those issues in a timely manner and communicating the problem to staff members for resolution. There is not a solution on the market at this time to efficiently discover and resolve issues during an event. The solution is Squad: a mobile application designed for event planners and their team to be able to discover issues and resolve them in a timely manner, using social media feeds and machine learning in the background to uncover crowd-generated issues.

### What is this repository for? ###

* Quick summary
* Version

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact

### Product Strategy ###

#### Product Potential ####
* Since no competitors (i.e. Eventbrite, Facebook) offer the ability to coordinate and control an event while it is going on, this product has the ability to give Splash a competitive edge and acquire more paying customers.  Presently, the competitive edge Splash has is a high design focus. Eventbrite does have a couple competitive advantages, such as a bulletin board of events based on location as well as the advantage of first-mover. 

#### User Acquisition ####
* This product is an add-on feature for paid users which could be included in the upcoming Splash Mobile App. Acquisition is made by advertising the feature on the website.  Additionally, with the download of the Splash App for the purposes of conducting Check-In, the additional features will be optional for use by the captured user.
* We also expect the marketing managers, who are our target clients, to influence the adoption of our app by event planning agencies they hired for big events. This has been validated by Splash employees who work closely with Splash’s bluechip clients.

### Market Size ###
* 100,000 total users → ~4,000 paying users (4%)
* 10% Enterprise Users ($999/Month) = ~$400,000
* 90% Producer Users ($249/Month) = ~$900,000

Estimate an increase in paying user total by 5% due to the addition of this new product:
* ~$65,000/month= $780,000/Year

### KPIs ###
* How many users download the app?
* What is the conversion rate, i.e., how many users are paying for the app?
* How many times do users visit the app per month?
* How long do users stay on the app during each visit?
* How many people create an agenda for their event on the web app?
* How many people use the post-event social analytics?

### Implementation Strategy ###

<img src="https://github.com/bplaster/CTSplashThat/blob/master/image/NCP%20arch.png" width="600px">

According to the NCP architecture shown above, we split the functions into three categories and prioritized them based on the analysis of complexity/impact, as is demonstrated in the prioritization matrix:

<img src="https://github.com/bplaster/CTSplashThat/blob/master/image/priority%20matrix.png" width="600px">

* Quick wins: this category includes the basic functions which reflect our narrative well, such as the function for staff members to report identified issues, take issues assigned by managers, and report progress of handling issues, as well as the function for manager to track all issues and manage them.

* Big ticket items: this category mainly includes the function of automatically detecting issues through social media such as twitter. Implementation of this function requires proper use of Alchemy API and twitter API, as well as finetune of the detection algorithm using dataset. It is a strong differentiator for our app but the complexity is high too. We will work on this function as long as we have time after getting those quick wins done.

* Schedule management: we also thought it would be useful for the planners to work on schedules before the event and have them imported to our app, so that both managers and staff members are able to track and be alerted about the event progress. It is not the key function though, and the complexity can be low or medium depending on specific feature design, so we decided to put it to lowest priority for now.
