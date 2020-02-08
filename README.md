# maRio

* I want to use `R` to its advantages (data manipulation, modeling, viz, etc.) and then host my work on a website. 
* I want to do this without recreating my work in `JS` plotting libraries.
* `Plumber` can be used to create REST API endpoints out of `R` objects/functions to be called from my website. 

## API Configuration
* This API will be hosted as a single backend service for all of my projects
* It is necessary to programmatically set up `Plumber` as a [mounted router](https://www.rplumber.io/docs/programmatic-usage.html#mount-static) due to all the different endpoints to manage

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

## Hosting
* `Plumber` has integrations with DigitalOcean but building a `Docker` image allows for more flexibility in hosting options
* Heroku is free (with caveats) so I have Dockerized the API, hosted it as a Heroku app, & integrated it into my [Express app](https://github.com/jbixon13/nodeblog)
* `Travis CI` is then set up to automatically re-build the hosted API whenever I push changes to the master branch
