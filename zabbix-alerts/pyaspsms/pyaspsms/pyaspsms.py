#!/usr/bin/env python
import yaml, json, requests

class ASPSMS():
    options = { "api": "https://json.aspsms.com/" }
    def __init__(self, **kwargs):
        self.options.update(kwargs)

    def SendTextSMS(self, **kwargs):
        self.options.update(kwargs)
        requires = [
            "UserName", "Password", "Recipients", "MessageText"
        ]
        optional = [
            "Originator", "DeferredDeliveryTime", "FlashingSMS",
            "URLBufferedMessageNotification", "URLDeliveryNotification",
            "URLNonDeliveryNotification", "AffiliateID", "ForceGSM7bit"
        ]
        data = {opt:self.options[opt] for opt in self.options if opt in requires + optional}
        if not all(map(lambda x: data.get(x, '') != '', requires)):
            return False
        content = requests.post("%(api)s/SendTextSMS" %(self.options), data=json.dumps(data))
        return content
    
    def SendSimpleTextSMS(self, **kwargs):
        self.options.update(kwargs)
        requires = [
            "UserName", "Password", "Recipients", "MessageText"
        ]
        optional = [
            "Originator", "ForceGSM7bit"
        ]
        data = {opt:self.options[opt] for opt in self.options if opt in requires + optional}
        if not all(map(lambda x: data.get(x, '') != '', requires)):
            return False
        content = requests.post("%(api)s/SendSimpleTextSMS" %(self.options), data=json.dumps(data))
        return content
    
    def CheckCredits(self, **kwargs):
        self.options.update(kwargs)
        requires = ["Username", "Password"]
        optional = []
        data = {opt:self.options[opt] for opt in self.options if opt in requires + optional}
        if not all(map(lambda x: data.get(x, '') != '', requires)):
            return False
        content = requests.post("%(api)s/CheckCredits" %(self.options), data=json.dumps(data))
        return content
    
def main():
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option("-c", "--config", dest="config",
                      help="Your ASPSMS configurations.",
                      metavar="ConfigFile")
    parser.add_option("-u", "--username", dest="username",
                      help="Your ASPSMS Userkey.",
                      metavar="UserName")
    parser.add_option("-p", "--password", dest="password",
                      help="Your ASPSMS Password.",
                      metavar="Password")
    parser.add_option("-o", "--originator", dest="originator",
                      help="You can use a phone number or up to 11 Alphabetic characters.",
                      metavar="Originator")
    parser.add_option("-r", "--recipients", dest="recipients", action="append",
                      help="Add Recipients as JSON Array.",
                      metavar="Recipients")
    parser.add_option("-m", "--message", dest="message",
                      help="The message text property accepts UTF8 encoding.",
                      metavar="MessageText")
    parser.add_option("-g", "--gsm7bit", dest="gsm7bit", default=False,
                      action="store_false",
                      help="""
                      Force sending GSM7bit characters only to avoid extra cost by acidentally 
                      using Unicode Characters.
                      """, 
                      metavar="ForceGSM7bit")    
    parser.add_option("-d", "--debug", dest="debug", default=False,
                      action="store_false",
                      help="Print status messages to stdout.",
                      metavar="Debug")
    (options, args) = parser.parse_args()
    
    if options.config:
        with open(options.config, 'r') as ymlfile:
            cfg = yaml.load(ymlfile)
            cfg['MessageText'] = options.message
            cfg['Recipients'] = options.recipients
    else:
        cfg = {
            'UserName': options.username,
            'Password': options.password,
            'Originator': options.originator,
            'Recipients': options.recipients,
            'MessageText': options.message,
            'ForceGSM7bit': options.gsm7bit
        }
    res = ASPSMS().sender.SendSimpleTextSMS(**cfg)
    print(res.content)
   
if __name__ == '__main__':
    main()
