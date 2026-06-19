# <img width="144" height="54" alt="no-logo" src="https://github.com/user-attachments/assets/88f0bab0-8308-4e04-b22f-442c24dbea19" /> [No_IP](https://www.noip.com/) Renewer for Home Assistant <img width="32" height="32" alt="icon" src="https://github.com/user-attachments/assets/41c45cfa-5734-4132-a1ee-d07734d45184" />

**Renewing No-IP hosts** with [simao-silva/noip-renewer docker container](https://github.com/simao-silva/noip-renewer) and Home Assistant tricks

This container adds the credentials to Simao's container via the Home Assistant GUI and a secondary Container.

Due to the limiting nature of Home Assistant containers some extra steps to make full use of this in Home Assitant are required, and will be detailed below.

- Login details _<- required_
- **optional sensors**
- IMAP sensor
- SSH sensor
- Github sensor to track Simoa's updates, as he usually updates when the No-IP webpage changes and breaks his container.

---

## Instructions

There are some [Known limitations](https://github.com/simao-silva/noip-renewer#known-issues--limitations) and you need the two factor authentaction setup correctly in you existing No-IP account.

**This container will fill in the details of this command.**

**That's all it does**

_This would start a normal docker container._

```
docker run --rm --env NO_IP_USERNAME=<EMAIL> --env NO_IP_PASSWORD=<PASSWORD> --env NO_IP_TOTP_KEY=<NOIP TOTP KEY> simaofsilva/noip-renewer:<TAG>
```

**You will need on hand**

- NO_IP_USERNAME (your email)
- NO_IP_PASSWORD
- NO_IP_TOTP_KEY

These can be added either as secrets in your secrets.yaml or directly into the GUI in Home Assistant.
<img width="500" height="569" alt="noip-config-page" src="https://github.com/user-attachments/assets/69ef29ca-3ff4-4b16-b34c-e386b7cd3a27" />

**The container runs one cycle per start and then logs off and exits.**

I use an **automation to start it,** which triggers via an [IMAP sensor](https://www.home-assistant.io/integrations/imap/)

```
#### Automation to Start container
alias: NOIP Expiring
description: NOIP expiring confirm hosts
triggers:
  - event_type: imap_content             #####  IMAP Sensor from EMAIL Subject line.
    id: noip_expiring_custom_event
    event_data:
      subject: "ACTION REQUIRED: your-NO-IP.ddns.net is Expiring Soon"
    trigger: event
conditions:
  - condition: template
    value_template: >-
      {{ 'ACTION REQUIRED: your-NO-IP.ddns.net is Expiring Soon' in
      trigger.event.data['subject'] }}
actions:
  - action: hassio.app_start            ##### Action to start the container
    metadata: {}                        ##### This is provided by Supervisor Integration (Devices and Services).
    data:                               ##### May need to be enabled the first time.
      app: 76aa2759_noip-renewer-ha    
 
mode: single

```

This Automation is the notification

```
alias: NOIP Fire Notify
description: ""
triggers:
  - trigger: state
    entity_id:                                    ##### Binary Sensor from Supervisor
      - binary_sensor.noip_renewer_ha_running     ##### This is provided by Supervisor Integration (Devices and Services).
    from:                                         ##### May need to be enabled the first time.
      - "on"
    to:
      - "off"
    for:
      hours: 0
      minutes: 0
      seconds: 5
conditions: []
actions:
  - action: homeassistant.update_entity
    metadata: {}
    data:
      entity_id:
        - sensor.noip_renewer_log
  - delay:
      hours: 0
      minutes: 0
      seconds: 10
      milliseconds: 0
  - metadata: {}
    data:
      message: >-
        NOIP hostnames have been triggered. Check if completed successfully. 


        {% for packages, value in
        states.sensor.noip_renewer_log.attributes.items() %}   {{ packages }}:
        {{ value }} {% endfor %}
      title: NOIP Hostnames
    action: notify.persistent_notification
mode: single

```

<img width="671" height="382" alt="Supervisor Integration" src="https://github.com/user-attachments/assets/75775945-d777-467b-afb0-e150674a274b" />


---

I use a SSH [command line sensor](https://www.home-assistant.io/integrations/command_line/#sensor) to send data to the persistant notification.

This isn't strictly required.

You could just send a normal notification and go to check the logs to confirm the action renewed your hosts.

```
###
ha host logs -t addon_e28361c6_noip-renewer | tail -n 14 | jq --raw-input --slurp '{ "packages": split("\n") | del(.[] | select(. == "" or . == "Listing...")) }'
```

Ha Host Logs command that can be run in either of the terminal addons.
It is three parts, and the enclosing brackets ( { ' " are very specific and change between the terminal command(_above_) and SSH command(_below_) so take careful not when copying commands.

- HA host logs command to the container
- tail -number of lines 14
- jq --slurp to output json attributes for the states sensor

The actual SSH command requires setting op of your keys to allow container to container communication.

```
###
command_line:
  - sensor:
      name: NOIP renewer log
      unique_id: noip_renewer_log1
      scan_interval: 30000000000
      command: >-
               ssh root@homeassistant.local -p 22222 -o UserKnownHostsFile=/config/.ssh/known_hosts -i /config/.ssh/id_rsa_ha 'ha host logs -t addon_e28361c6_noip-renewer' | tail -n 14 | jq --raw-input --slurp '{ "packages": split("\n") | del(.[] | select(. == "" or . == "Listing...")) }'
      value_template: '{{ value_json.packages | length | default() }}'
      json_attributes:
        - packages
```

<img width="517" height="215" alt="noip-notif" src="https://github.com/user-attachments/assets/0f69e4c6-3b99-46ef-8873-426cd0311d4e" />

<img width="32" height="32" alt="icon" src="https://github.com/user-attachments/assets/41c45cfa-5734-4132-a1ee-d07734d45184" />

---

Back up notification on expired email subject.

Just in case the first is missed.

```
alias: NOIP Expired confirm hostnames
description: NOIP expired confirm hosts
mode: single
triggers:
  - event_type: imap_content
    id: noip_expiring_custom_event
    event_data:
      subject: "ACTION REQUIRED: your-No-IP.ddns.net has Expired"
    trigger: event
conditions:
  - condition: template
    value_template: >-
      {{ 'ACTION REQUIRED: your-No-IP.ddns.net has Expired' in
      trigger.event.data['subject'] }}
actions:
  - metadata: {}
    data: {}
    target:
      entity_id: sensor.noip_renewer_log
    action: homeassistant.update_entity
  - metadata: {}
    data:
      message: >-
        EXPIRED NOIP hostnames have been triggered. Check if completed
        successfully.
      title: NOIP Hostnames EXPIRED
    action: notify.persistent_notification

```

<img width="144" height="54" alt="no-logo" src="https://github.com/user-attachments/assets/88f0bab0-8308-4e04-b22f-442c24dbea19" />
