# Docs: https://just.systems/man/en/

project_name := "format-docx"
app_py := "src/app_main.py"
server_port := "8080"

set dotenv-load

# show available commands
help:
  @just -l

# create the local Python venv (.venv) and install requirements(.txt)
setup-python-venv:
	python3 -m pip install --upgrade pip
	python3 -m venv .venv
	. .venv/bin/activate
	pip-compile requirements.in
	pip install -r requirements.txt


# run app.py (in Streamlit) locally
run: 
    streamlit run {{app_py}} --server.port={{server_port}} --server.address=localhost

update-reqs:
    pip-compile requirements.in

# check what instances of streamlit are running
ps-streamlit:
    ps -ef | grep streamlit | grep -v grep | grep -v just


# build and run app.py in a (local) docker container
run-container: 
    docker build . -t {{project_name}}
    docker run -p {{server_port}}:{{server_port}} {{project_name}}

# in progress
gcloud-setup:
    gcloud config set region asia-southeast2
    gcloud services enable cloudbuild.googleapis.com
    gcloud config set project {{project_name}}
    gcloud beta billing projects link {{project_name}} --billing-account $BILLING_ACCOUNT_GCP

# deploy container to Google Cloud (Cloud Run) - preferred / cheaper
gcloud-deploy-cloud-run: 
    gcloud run deploy --source . {{project_name}}


# deploy container (including app.py) to Google Cloud (App Engine)
gcloud-deploy-app-engine:
    # gcloud projects delete {{project_name}}
    # gcloud projects create {{project_name}}
    # gcloud config set project {{project_name}}
    gcloud app deploy app.yaml  


gcloud-view:
    gcloud app browse


gcloud-app-disable:   # deleting project does not delete app
    gcloud app versions list
# gcloud app versions stop {{VERSION.ID}}

gcloud-info:
    gcloud projects list