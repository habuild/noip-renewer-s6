import json
import os
from pathlib import Path
from datetime import datetime

"""
# Debug data
os.environ['NO_IP_USERNAME'] = 'email@email.com'
os.environ['NO_IP_PASSWORD'] ='passhide'
os.environ['NO_IP_TOTP_KEY'] = 'rn789237'
os.environ['TRANSLATE_ENABLED'] = 'False'
os.environ['SHOW_PASS'] = 'false'
"""

def HA_addon_options():
    """
    Import credentials from data/options.json for Home Assistant credentials from an Addon.

    # Point to the separate directory and file
    # (e.g., a folder named "data" sitting next to your script)
    """

    # 1. finds the 'app' folder 
    current_dir = Path(__file__).resolve().parent

    # 2. Moves up to the main project folder
    project_root = current_dir.parent
 
    # 3. Finds the data directory and options.json file
    file_path = project_root / "data" / "options.json"

    # Verify path is available
    if file_path.exists():
        print(file_path.exists())
                
        # Open and parse the OPTIONS.JSON file
        with open(file_path, "r") as file:
                options_data = json.load(file)
        
        # Inject each key-value pair into the system environment
        for key, value in options_data.items():
                os.environ[key] = str(value)

        # Get current local time with system timezone attached
        local_dt = datetime.now().astimezone()
        print(local_dt.strftime("%Y-%m-%d %H:%M:%S %Z %z"))

        """
        # Verification of file inputs. not needed active
        """
        print('Email:', os.environ.get('NO_IP_USERNAME'))  # Outputs: User@Email.com
        
        # The dynamic switch (True means show text, False means mask text)
        show_pass = (os.getenv('SHOW_PASS')) == 'true'
        
        # Check the dynamic switch
        text_pass = (os.getenv('NO_IP_PASSWORD'))
        
        if show_pass:
            print('Password:', text_pass)
        else:
            print('Password:', "*" * len(text_pass))
        
        # Check the dynamic switch    
        text_totp = (os.getenv('NO_IP_TOTP_KEY'))
        
        if show_pass:
            print('TOTP Key:', text_totp)
        else:
            print('TOTP Key:', "*" * len(text_totp))
            
        print('Translating No-IP website:', os.environ.get('TRANSLATE_ENABLED'))
    else:
        pass
HA_addon_options()
