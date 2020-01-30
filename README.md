# maRio

* I want to use R to its advantages (data manipulation, modeling, viz, etc.) and then host my work on a website. 
* I want to do this without recreating my work in JS plotting libraries.
* Plumber can be used to create REST API endpoints out of R objects/functions to be called from my website. 

## Plumber structure
* This API will be hosted as a single backend service for all of my projects
* It is necessary to programmatically set up Plumber as a [mounted router](https://www.rplumber.io/docs/programmatic-usage.html#mount-static) due to all the different endpoints to manage

```sh
mario
|   plumber.R (root router)
|   
|└──project_1
|   │   plot.R (endpoints defined here)
|
|└──project_2
|   │   plot.R (endpoints defined here)
```
