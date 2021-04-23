---
id: documentation
title: Documentation
---

The documentation can be found in the `/docs` directory. When Docker is running the documentation site
is served locally using [Docusaurus](https://docusaurus.io/) at [http://localhost:3002/murfin_method](http://localhost:3002/murfin_method).
Any changes made in the `/docs` directory will be immediately visible in the local version of the documentation.

We also serve the documentation online at [https://sardjv.github.io/murfin_method/](https://sardjv.github.io/murfin_method/).

To deploy the latest changes to the online documentation site, make sure Pages is activated on Github/settings and the branch
is set to `gh-pages` and `root`. CircleCI automatically deploys changes to the site, you can find the config for this
in `.circleci/config.yml` under the `deploy_docs` job.
