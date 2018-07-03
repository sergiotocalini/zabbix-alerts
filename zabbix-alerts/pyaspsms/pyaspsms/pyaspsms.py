#!/usr/bin/env python
import yaml, json, requests

class ASPSMS():
    options = { "api": "https://json.aspsms.com/" }
    def __init__(self, **kwargs):
        self.options.update(kwargs)

    def __do_request__(self, api, requires=[], optional=[]):
        data = {opt:self.options[opt] for opt in self.options if opt in requires + optional}
        if not all(map(lambda x: data.get(x, '') != '', requires)):
            return False
        content = requests.post(api, data=json.dumps(data))
        return content
        
    def CheckCredits(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/CheckCredits" %(self.options)
        requires = ["Username", "Password"]
        return self.__do_request__(api, requires)
        
    def SendTextSMS(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/SendTextSMS" %(self.options)
        requires = [ "UserName", "Password", "Recipients", "MessageText" ]
        optional = [
            "Originator", "DeferredDeliveryTime", "FlashingSMS",
            "URLBufferedMessageNotification", "URLDeliveryNotification",
            "URLNonDeliveryNotification", "AffiliateID", "ForceGSM7bit"
        ]
        return self.__do_request__(api, requires, optional)
    
    def SendSimpleTextSMS(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/SendSimpleTextSMS" %(self.options)
        requires = [ "UserName", "Password", "Recipients", "MessageText" ]
        optional = [ "Originator", "ForceGSM7bit" ]
        return self.__do_request__(api, requires, optional)

    def InquireDeliveryNotifications(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/InquireDeliveryNotifications" %(self.options)
        requires = [ "UserName", "Password", "TransactionReferenceNumbers" ]
        return self.__do_request__(api, requires)

    def SendOriginatorUnlockCode(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/SendOriginatorUnlockCode" %(self.options)
        requires = [ "UserName", "Password", "Originator" ]
        return self.__do_request__(api, requires)

    def UnlockOriginator(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/UnlockOriginator" %(self.options)
        requires = [ "UserName", "Password", "Originator", "UnlockCode", "AffiliateID" ]
        return self.__do_request__(api, requires)

    def CheckOriginatorAuthorization(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/CheckOriginatorAuthorization" %(self.options)
        requires = [ "UserName", "Password", "Originator" ]
        return self.__do_request__(api, requires)

    def SendTokenSMS(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/SendTokenSMS" %(self.options)
        requires = [
            "UserName", "Password", "Originator", "Recipients", "VerificationCode"
        ]
        options = [
            "MessageData", "TokenValidity", "TokenMask", "TokenReference",
            "TokenCaseSensitive", "URLBufferedMessageNotification", "URLDeliveryNotification",
            "URLNonDeliveryNotification", "AffiliateID"
        ]
        return self.__do_request__(api, requires, optional)

    def VerifyToken(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/VerifyToken" %(self.options)
        requires = [
            "UserName", "Password", "PhoneNumber", "TokenReference", "VerificationCode"
        ]
        return self.__do_request__(api, requires)

    def CreateVoucher(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/CreateVoucher" %(self.options)
        requires = [
            "UserName", "Password", "NumberOfVouchers", "AmountCreditsPerVoucher", "Remarks"
        ]
        return self.__do_request__(api, requires)    

    def GetVoucherTransactions(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/GetVoucherTransactions" %(self.options)
        requires = [ "UserName", "Password" ]
        return self.__do_request__(api, requires)    

    def RedeemVoucher(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/RedeemVoucher" %(self.options)
        requires = [ "UserName", "Password" ]
        return self.__do_request__(api, requires)

    def VersionInfo(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/VersionInfo" %(self.options)
        return self.__do_request__(api)

    def ListAllStatusCodes(self, **kwargs):
        self.options.update(kwargs)
        api = "%(api)s/ListAllStatusCodes" %(self.options)
        return self.__do_request__(api)

def main():
    from logging import getLogger, FileHandler, Formatter
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

    logger = getLogger('pyaspsms')
    if options.debug:
        handler = FileHandler('/var/log/pyaspsms.log')
        handler.setFormatter(Formatter(
            """%(asctime)s - %(name)s - %(levelname)s - %(message)s""",
            "%Y-%m-%d %H:%M:%S"
        ))
        logger.addHandler(handler)
        logger.setLevel('INFO')
    
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
    res = ASPSMS().SendSimpleTextSMS(**cfg)
    logger.info(res.content)
   
if __name__ == '__main__':
    main()
