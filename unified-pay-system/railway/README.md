# Railway staged production deployment

This directory intentionally starts Unified Pay V0.18 with **GMPay only** for the first real-money E2E. PayPal remains in the reviewed V0.18 source bundle but is not enabled by this Railway overlay until PayPal Sandbox E2E and production secret rotation are complete.

Required runtime secret variables are injected by Railway and are never committed to this repository.
