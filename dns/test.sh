#!/bin/bash
#
# Test for Kubernetes DNS.
#
# $1: "canary" or "prod"

#set -x
#set -e

if [ "$1" != "canary" -a "$1" != "prod" ]; then
    echo "usage: $0 <canary|prod>"
    exit 1
fi

SERVER_CANARY_K8S=ns-cloud-c1.googledomains.com.
SERVER_CANARY_KUBERNETES=ns-cloud-b1.googledomains.com.
SERVER_PROD_K8S=ns-cloud-d1.googledomains.com.
SERVER_PROD_KUBERNETES=ns-cloud-a1.googledomains.com.
echo $1

if [ "$1" == "canary" ]; then
    SERVER_K8S="${SERVER_CANARY_K8S}"
    SERVER_KUBERNETES="${SERVER_CANARY_KUBERNETES}"
    ZONE_PFX="canary."
else # "prod"
    SERVER_K8S="${SERVER_PROD_K8S}"
    SERVER_KUBERNETES="${SERVER_PROD_KUBERNETES}"
    ZONE_PFX=""
fi

echo "Testing $1 via ${SERVER_K8S} and ${SERVER_KUBERNETES}"

R=$(dig +short -t A "@${SERVER_K8S}" "${ZONE_PFX}k8s.io")
if [ "$R" != 23.236.58.218 ]; then
    echo "FAIL: A ${ZONE_PFX}k8s.io:"
    echo "  got:"
    echo "$R"
    echo "--------------------"
    exit 2
fi
R=$(dig +short -t MX "@${SERVER_K8S}" "${ZONE_PFX}k8s.io")
echo $R
if [ "$R" != 23.236.58.218 ]; then
    echo "FAIL: MX ${ZONE_PFX}k8s.io:"
    echo "  got:"
    echo "$R"
    echo "--------------------"
    exit 2
fi

echo "PASS"

exit 0
### Input data for k8s.io below...
# The top-level k8s.io zone
'':
  - type: A
    value: 23.236.58.218 # Our vanity redirector, hosted in GKE
  - type: MX
    values:
    - exchange: aspmx.l.google.com.
      preference: 1
    - exchange: alt1.aspmx.l.google.com.
      preference: 5
    - exchange: alt2.aspmx.l.google.com.
      preference: 5
    - exchange: alt3.aspmx.l.google.com.
      preference: 10
    - exchange: alt4.aspmx.l.google.com.
      preference: 10
  - type: TXT
    values:
    - google-site-verification=RJbZ_ganmSWvslSKOBG-QHv62XTjJZcigpWIFttStFs
    - v=spf1 include:_spf.google.com ~all
www:
  type: CNAME
  value: k8s.io.

# Canary zone for testing DNS pushes.
canary:
  type: NS
  values:
  - ns-cloud-c1.googledomains.com.
  - ns-cloud-c2.googledomains.com.
  - ns-cloud-c3.googledomains.com.
  - ns-cloud-c4.googledomains.com.

# Our vanity redirector.  This is not just 'k8s.io', on the off chance this
# becomes different from the main record. (@thockin)
redirect:
  type: A
  value: 23.236.58.218

# Main docs site is a redirect (@chenopis)
docs:
  type: CNAME
  value: redirect.k8s.io.
# All docs subdomains get sent to netlify (@chenopis)
'*.docs':
  type: CNAME
  value: netlifyglobalcdn.com.

# Prove that we own these github orgs. sig-contributor-experience
_github-challenge-kubernetes:
  type: TXT
  value: 8d02d39186
_github-challenge-kubernetes-client:
  type: TXT
  value: 8135eb1976
_github-challenge-kubernetes-csi:
  type: TXT
  value: 5aa2511ab7
_github-challenge-kubernetes-incubator:
  type: TXT
  value: cc457b8e52
_github-challenge-kubernetes-retired:
  type: TXT
  value: b36f0d3bca
_github-challenge-kubernetes-sigs:
  type: TXT
  value: c576f646fc

# Download sites
apt:
  type: CNAME
  value: redirect.k8s.io.
yum:
  type: CNAME
  value: redirect.k8s.io.
dl:
  type: CNAME
  value: redirect.k8s.io.
rel:
  type: CNAME
  value: redirect.k8s.io.
releases:
  type: CNAME
  value: redirect.k8s.io.

# Vanity CNAMEs.
blog:
  type: CNAME
  value: redirect.k8s.io.
changelog:
  type: CNAME
  value: redirect.k8s.io.
ci-test:
  type: CNAME
  value: redirect.k8s.io.
code:
  type: CNAME
  value: redirect.k8s.io.
contributor:
  type: CNAME
  value: kubernetes-contributor.netlify.com.
# Code search (@dims)
# TODO: Where does this run?
cs:
  type: A
  value: 147.75.97.58
# sig-contributor-experience
devstats:
  type: CNAME
  value: k8s.devstats.cncf.io.
# sig-contributor-experience
discuss:
  type: CNAME
  value: kubernetes.hosted-by-discourse.com.
examples:
  type: CNAME
  value: redirect.k8s.io.
feature:
  type: CNAME
  value: redirect.k8s.io.
features:
  type: CNAME
  value: redirect.k8s.io.
# Web frontend for unauthenticated GCS access.  Running in GKE (@thockin).
gcsweb:
  type: A
  value: 104.197.177.166
get:
  type: CNAME
  value: redirect.k8s.io.
git:
  type: CNAME
  value: redirect.k8s.io.
# URL shortener service.
go:
  type: CNAME
  value: redirect.k8s.io.
#TODO: seems to send to main site, @ixdy to followup
gubernator:
  type: CNAME
  value: redirect.k8s.io.
issue:
  type: CNAME
  value: redirect.k8s.io.
issues:
  type: CNAME
  value: redirect.k8s.io.
# Running in GKE (@dchen1107).
node-perf-dash:
  type: A
  value: 130.211.155.47
# sig-scalability
perf-dash:
  type: A
  value: 35.188.102.189
pr:
  type: CNAME
  value: redirect.k8s.io.
pr-test:
  type: CNAME
  value: redirect.k8s.io.
# Running in a GKE cluster somewhere (@ixdy).
prow:
  type: A
  value: 35.186.196.185
prs:
  type: CNAME
  value: redirect.k8s.io.
sigs:
  type: CNAME
  value: redirect.k8s.io.
# Running on a GCE VM (@grodrigues3, @roberthbailey).
slack:
  type: A
  value: 104.197.79.9
# Voluntary cluster data collector. Runs in GKE (@thockin).
spartakus:
  type: A
  value: 107.178.240.20
# Prow (@ixdy).
submit-queue:
  type: CNAME
  value: redirect.k8s.io.
# Kops testing e2e (@justinsb).
test-cncf-aws:
  type: NS
  values:
  - ns-1458.awsdns-54.org.
  - ns-1825.awsdns-36.co.uk.
  - ns-265.awsdns-33.com.
  - ns-687.awsdns-21.net.
# @michelle192837
testgrid:
  type: CNAME
  value: redirect.k8s.io.
# Project metrics.  Running in GKE (@spiffxp, @cjwagner)
velodrome:
  type: A
  value: 104.197.200.129
