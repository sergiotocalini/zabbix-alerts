# pyaspsms
This is a python library and a handler script which allows you to send SMS message using the provider ASPSMS (see the link in references).

## Python Library
This script also can be used as a python library and there is a setup.py that give you the chance to install in the python path.
```
~# git clone https://github.com/sergiotocalini/zabbix-alerts.git
~# cd zabbix-alerts/pyaspsms
~# pip install .
~# pyaspsms -h
Usage: pyaspsms.py [options]

Options:
  -h, --help            show this help message and exit
  -c ConfigFile, --config=ConfigFile
                        Your ASPSMS configurations.
  -u UserName, --username=UserName
                        Your ASPSMS Userkey.
  -p Password, --password=Password
                        Your ASPSMS Password.
  -o Originator, --originator=Originator
                        You can use a phone number or up to 11 Alphabetic
                        characters.
  -r Recipients, --recipients=Recipients
                        Add Recipients as JSON Array.
  -m MessageText, --message=MessageText
                        The message text property accepts UTF8 encoding.
  -g, --gsm7bit                                Force sending GSM7bit
                        characters only to avoid extra cost by acidentally
                        using Unicode Characters.
  -d, --debug           Print status messages to stdout.
~#
```

# References
* [ASPSMS](https://www.aspsms.com/)
