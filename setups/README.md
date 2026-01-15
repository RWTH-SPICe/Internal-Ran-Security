# Evaluation of Security-Induced Latency in 5G RAN Interfaces and User Plane Communication

## Available scenarios

### A) `setup RAN`
This directory contains the configurations and Docker setups for the basic scenario. This includes a 5G network with disaggragted internal RAN into Distributed Unit (DU), Central Unit Control Plane (CU-CP) and Central Unit User Plane (CU-UP). 

### B) `setup N3`
In addition to the disaggragted RAN, this setup also provides the option of enabling IPsec on top of the N3 interface. 

### C) `setup Monolithic`
Contrary to setups A) and B), the setup in this directory consists out of a monolithic RAN. The option to enable IPsec on top of the N3 interface is still available here. 

## Usage

Navigate to the setup you want to use, e.g. setup RAN
```bash
cd "setups/setup RAN"
```

Choose the desired security setting, e.g. IPsec
```bash
cd "IPsec"
```

Build all necessary images. You should only have to run this once per setup option, unless you want to make changes to the images.
```bash
./build.sh
```

Deploy the setup. In some cases, you might need to run this as root.
```bash
docker compose up
```

The Open5GS webinterface should now be available [here](http://127.0.0.1:9999) (admin:1423).

Attach to the UE container (e.g. to ping the UPF's CN interface (ping -I oaitun_ue1 192.168.200.100)).
The container name is in the form **rfsim5g-nr-oai-ue-SETTING** (SETTING being noenc, ipsec or dtls).

```bash
docker exec -it rfsim5g-nr-oai-ue-ipsec /bin/bash
```
## Requirements

In order to run the setup, the following dependencies are required:
```
- Docker
```

## Uu integrity and encryption

If Uu integrity or encryption is desired, it needs to be enabled in the CUCP or GNB config in the desired setup.

Navigate to the OAI configs of the setup you want to use
```bash
cd "setups/setup RAN/IPsec/OpenAirInterface-Docker/configs"
```

Choose the desired integrity or encryption algorithm and enable it on the User Plane
Integrity on the Control Plane is mandatory and required for the setup to work
If you want to disable integrity on the User Plane, flip drb_integrity to "no".

```security = {
  # preferred ciphering algorithms
  # the first one of the list that an UE supports in chosen
  # valid values: nea0, nea1, nea2, nea3
  ciphering_algorithms = ( "nea0" );

  # preferred integrity algorithms
  # the first one of the list that an UE supports in chosen
  # valid values: nia0, nia1, nia2, nia3
  integrity_algorithms = ( "nia2" );

  # setting 'drb_ciphering' to "no" disables ciphering for DRBs, no matter
  # what 'ciphering_algorithms' configures; same thing for 'drb_integrity'
  drb_ciphering = "yes";
  drb_integrity = "yes";
};
```