# UPP - Publish varnish

The Publishing Varnish routing proxy placed after the publishing auth varnish. Its role is to route traffic based on the context path in the URL to appropriate services.

## Code

k8s-pub-path-routing-varnish

## Primary URL

<https://upp-prod-publish-glb.upp.ft.com/>

## Service Tier

Platinum

## Lifecycle Stage

Production

## Delivered By

content

## Supported By

content

## Known About By

- mihail.mihaylov
- hristo.georgiev
- elitsa.pavlova
- kalin.arsov
- elina.kaneva
- georgi.ivanov

## Host Platform

AWS

## Architecture

This Varnish instance is responsible for dinamically forwarding requests to services and cache management based on the context path in the URL. Dynamic routing means that Varnish will send requests to Kubernetes services with more that one pod. This will ensure that traffic will be distributed to all pods of particular microservice. Initial authentification is already performed in service "UPP - Publish varnish".

## Contains Personal Data

No

## Contains Sensitive Data

No

## Dependencies

- k8s-pub-auth-varnish

## Failover Architecture Type

ActivePassive

## Failover Process Type

FullyAutomated

## Failback Process Type

FullyAutomated

## Failover Details

The service is deployed in all clusters. The failover guide for the clusters is located here: <https://github.com/Financial-Times/upp-docs/tree/master/failover-guides/publishing-cluster>

## Data Recovery Process Type

FullyAutomated

## Data Recovery Details

Data for requests is stored in Splunk. Authentification secrets are encrypted and stored in Publishing clusters and in emergency LastPass note "UPP - k8s Basic Auth".

## Release Process Type

FullyAutomated

## Rollback Process Type

Manual

## Release Details

The deployment is automated.

## Key Management Process Type

None

## Key Management Details

There are no keys for rotation.

## Monitoring

- https://upp-prod-publish-us.upp.ft.com/__health
- https://upp-prod-publish-eu.upp.ft.com/__health

## First Line Troubleshooting

https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting

## Second Line Troubleshooting

Please refer to the https://github.com/Financial-Times/k8s-pub-path-routing-varnish/blob/master/README.md
