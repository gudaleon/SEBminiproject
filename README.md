# SEB Mini-project
## Research Phase
* Find a good metric for testing different spieces against one another
* Decide on different enviroments to be tested 

## Coding Phase 
* Matlab Differential Equations: 
	- **Aim:** To have simple equations which dictate the behaviour of the cell when nitrogen/carbon/sunlight are altered 
* Smoldyn Model: 
	- **Aim:** To represent the diffusion across different cells of the nitrogen. 
* F# model: 
	- **Aim:** to have a model which represents the growth of the cluster of cells
	- **Tasks:** 
		- compile the existing code for the Hybrid Modelling tool 
		- test the existing code for any further issues 
		- try to alter the size parameter in the hybrid testing model to instead represent nitrogen content. 

		
## Quick thing on how to use git 
### how to push to git 
* git add < file.name > 
* git commit  -m '< message > '
* git push 
  
### how to pull from git 
* cd SEBminiproject (from your home directory)
* git pull 

### If it doesn't let you do either of those things there is probably a conflict
* do a diff by typing git diff 
* enter the files it says are conflicted and remove the conflict/resolve the conflict 
* do a git merge 
* then do a git pull
* git push 
