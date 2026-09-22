from __future__ import annotations

from threading import RLock

_LOCK = RLock()
_PINS: dict[str, str] = {}


def pin(hostname: str, ip: str) -> None:
    with _LOCK:
        _PINS[hostname.rstrip(".").lower()] = ip


def get(hostname: str) -> str | None:
    with _LOCK:
        return _PINS.get(hostname.rstrip(".").lower())


def clear() -> None:
    with _LOCK:
        _PINS.clear()


def snapshot() -> dict[str, str]:
    with _LOCK:
        return dict(_PINS)
