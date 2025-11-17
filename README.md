# mirador-aiiinotate

Reference implementation of [aiiinotate](https://github.com/Aikon-platform/aiiinotate) with [mirador 4](https://github.com/ProjectMirador/mirador), using [mirador-annotations-editor](https://github.com/TETRAS-IIIF/mirador-annotation-editor/stargazers), including a Docker deploy to orchestrate all those components.

This implementation can be used in 2 ways:
- dev, or local usage
- prod, using Docker containers.

---

## Dev / local usage

In dev, we use bash scripts and commands defined in `package.json` to setup and use all components.

```bash
# clone the repo and cd in it
git clone git@github.com:paulhectork/mirador-aiiinotate.git
cd mirador-aiiinotate

# setup your .env. if you want your .env elsewhere, see the "Env management" section below.
cp .env.template .env
# here, you should manually complete your .env to your requirements

# install mongodb
bash scripts/setup_mongodb.sh

# setup the apps
npm run setup path-to-env-file

# build and serve mirador
npm run start-dev
```

--- 

## Prod / Docker usage

The docker architecture  orchestrates 3 containers:
- `mongo`: a mongo database
- `aiiinotate`: the application server (used as a backend for `mirador`)
- `mirador`: Mirador 4 integrated with Mirador-Annotations-Editor

Usage:

1. Install [Docker](https://docs.docker.com/engine/install/)
2. Setup your docker
```bash
# clone the repo and cd in it
git clone git@github.com:paulhectork/mirador-aiiinotate.git
cd mirador-aiiinotate

# setup your .env. if you want your .env elsewhere, see the "Env management" section below.
cp .env.template .env
# here, you should manually complete your .env to your requirements

# build your docker images and serve your app
bash docker/docker.sh build path-to-env-file
# after a first build, if your app has not changed, you can just serve the image you build before:
bash docker/docker.sh start path-to-env-file
```

---

## Environment management

In the examples above, the `.env` is always at the root of the repository. But 
- your .env can be anywhere in your machine. 
- it is also possible to add to an external `.env` the contents defined in `.env.template`

In any case, the `path-to-env-file` argument in the scripts above should be modified to reflect the actual path of your `.env`.

---

## License 

GNU GPL 3.0
