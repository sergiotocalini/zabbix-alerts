#!/usr/bin/env python
from logging import getLogger, FileHandler, Formatter
from optparse import OptionParser, OptionGroup
from webhooks import WebHooks
import json

def main():
    parser = OptionParser()
    parser.add_option(
        "-a", "--action",
        type = 'choice',
        action = 'store',
        dest = "action",
        choices = [ 'webhooks'],
        default = 'webhooks',
        help = "Action to perform (default=webhooks)"
    )
    parser.add_option(
        "-p", "--payload", dest="payload",
        help="Payload to send request to Microsoft Teams.",
    )
    parser.add_option(
        "-u", "--url", dest="url",
        help="Microsoft Teams URL.",
    )
    
    opts, args = parser.parse_args()
    if 'webhooks' == opts.action:
        wh = WebHooks(
            hookurl = opts.url,
            payload = json.loads(opts.payload)
        )
        r = wh.send_message()
        print(r.content)

if __name__ == '__main__':
    main()
