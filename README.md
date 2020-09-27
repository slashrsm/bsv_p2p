# Bitcoin (SV) P2P client

[![Build Status](https://travis-ci.org/slashrsm/bsv_p2p.svg?branch=master)](https://travis-ci.org/slashrsm/bsv_p2p)
[![Coverage Status](https://coveralls.io/repos/slashrsm/bsv_p2p/badge.svg?branch=master)](https://coveralls.io/r/slashrsm/bsv_p2p?branch=master)
[![Inline docs](http://inch-ci.org/github/slashrsm/bsv_p2p.svg)](http://hexdocs.pm/bsv_p2p/)
[![Hex Version](http://img.shields.io/hexpm/v/bsv_p2p.svg?style=flat)](https://hex.pm/packages/bsv_p2p)

A client library to talk to the Bitcoin (BSV) server network (also known as Peer-to-Peer network). Under active development.

See [docs on the official wiki](https://wiki.bitcoinsv.io/index.php/Peer-To-Peer_Protocol) for more info about the protocol and message types.

**Warning:** [Forked version](https://github.com/slashrsm/bsv-ex/) of `:bsv` library should be used in order for this library to work. There are two pull requests against the upstream library that this library depends on ([[1](https://github.com/libitx/bsv-ex/pull/3)], [[2](https://github.com/libitx/bsv-ex/pull/4)]).

## Implemented features

- Constructing and parsing of various messages
  - Blocks
  - Headers
  - Transactions
  - Addresses
  - Inventory
  - Mempool
  - Ping/Pong
  - Version/Verack (connection negotiation)

## Missing/planned features

- Compact blocks
- Bloom filtering
- GenServer for peer connection handling
- Connection pools

## Code contributions

Code contributions are welcome in form of GitHub pull requests. I strive to maintain highest quality standards, which includes 100% test coverage (where possible), standard code formatting, type specs, ...

In order to check the code before submitting a pull request use

```
mix check 
```

which will perform various checks and generate a report.

## License

Copyright © 2020 Janez Urevc

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.