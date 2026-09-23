# Reviewer Decision — K6 VPS Production Deployment Owner Checkpoint

Date: 2026-09-23
Status: OWNER_AUTHORIZATION_REQUIRED
Parent: K5 Release Candidate PASS

## Objective

Deploy the accepted Mini Craft Release Candidate to the existing shared Hostinger VPS using the established shared-VPS constraints:

- public 80/443 remain centrally managed;
- use reverse proxy;
- application under /srv/apps;
- project-isolated Docker Compose;
- do not disturb unrelated apps;
- production origin: https://minicraft.spikersun.com

## Proposed deployment mode

SANDBOX_CANARY_FIRST

The first public deployment is infrastructure validation only.

It must not immediately become an unrestricted real-money storefront.

## Pre-deploy requirements

Before any write:
1. read current shared VPS handoff / infrastructure truth;
2. inventory current 80/443 reverse proxy and active apps;
3. prove target ports/names/paths do not collide;
4. create rollback plan;
5. preserve unrelated services;
6. update deployment manifest target image to wordpress:7.1.1-php8.3-apache;
7. never expose secret values in GitHub/chat.

## Authorized only after Owner approval

After explicit Owner authorization, Executor may:
- create /srv/apps/mini-craft-night-kit or the canonical non-conflicting project path;
- deploy project-isolated WordPress + MariaDB Compose;
- import accepted K5 database/wp-content/config using production-safe secrets;
- configure internal application networking;
- configure reverse-proxy route for minicraft.spikersun.com;
- configure/verify HTTPS if compatible with existing shared infrastructure;
- perform URL migration localhost:8093 → https://minicraft.spikersun.com;
- run public canary health checks;
- keep PayPal in Sandbox for the first canary unless a later Owner checkpoint explicitly authorizes Live.

## Not authorized by this checkpoint

- PayPal Live
- real payment
- enabling test JPY 1 product for public sale
- public sale with MCK-LOCAL-TEST-001
- supplier contact
- advertising
- mass SEO
- destructive changes to unrelated VPS apps
- deletion of existing shared infrastructure
- credential publication

## Owner response

To authorize the deployment phase, Owner may reply exactly:

AUTHORIZE_K6_VPS_DEPLOYMENT

This authorizes bounded Sandbox-first deployment, not Live PayPal or real-money launch.
