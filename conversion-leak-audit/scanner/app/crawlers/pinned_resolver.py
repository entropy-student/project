from __future__ import annotations

# Imported only in Scrapy/Twisted runtime. Local unit tests can validate the pin registry
# even when Twisted is not installed in the sandbox.
from twisted.internet import defer
from twisted.internet.interfaces import IResolverSimple
from zope.interface import implementer

from .pinning import get


@implementer(IResolverSimple)
class PinnedResolver:
    def __init__(self, reactor):
        self.reactor = reactor

    @classmethod
    def from_crawler(cls, crawler, reactor):
        return cls(reactor)

    def install_on_reactor(self) -> None:
        self.reactor.installResolver(self)

    def getHostByName(self, name, timeout=()):
        value = get(name)
        if value is None:
            return defer.fail(RuntimeError(f"UNPINNED_DNS_HOST:{name}"))
        return defer.succeed(value)
