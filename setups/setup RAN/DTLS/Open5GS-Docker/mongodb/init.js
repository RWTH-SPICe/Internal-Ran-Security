db = db.getSiblingDB('open5gs');
db.createCollection('accounts');

open5gsuser = {
    roles: [ 'admin' ],
    username: 'admin',
    salt: 'e8b600a407744ed06fdb3fda7781e6374c3fd94757c92ad2c681b4c2cf84c7f6',
    hash: 'ada34b7267f2b9f89a17fa31e93e14adfcaa4e09bc881c66a2bf882d39ac25f3748356cfbda59fee83d4cf1ddcd277f79313a9a1681905eb374ade87b96d717c109c312cf5ebd1cc55a9ae4b6fcf42a4b415ee828745782e6fe38c8574a3a7df65eb6da1a68dcc4fe8fc5440fa8813d1c6b7e5b4bc5b52afc17282201c5aa1d1ae203cce020c17ebe8f8599d99138a811b4ac70346a70beec1665eb7d06a1b06f907ce1175b0b7d5a7800b7c956c56830f8932d3c86a8ca6068c2437c6f3e5a17d27073d87e6e0681703c591706aa4acc6383b835ade2a86f5561456b9469886c30dceea5f831b64c4d3bca926e9287df5177b69d4d6b46237c0351c760676e384db0dac4e29051b872c6d96df77935507a4393a5c73f830958eb8c7e98a8ba69b9a2d2a9e48968e10d8cddd441c0b1c53e9884f97ef4f812ab682c3ffe55cc46d4921ba9fabe6e5e8a94f60d30fbc0f456711dddec5f05dc90a39566bbe4c682c4d89594cb7f0953bd3972e917ef2cc394c6e95e746c3dc9aea66f9aa56d2f6f9e983a38fa955df68ba4186c13d146a7e5140bcbf3a14d11a307dee3bfb2d128b8cc7af20f94e14a23c49cecb8f9212392a05dc803ba7244551307edc08861fa798d2b89adbe04cee224d2b6f33b3e5d07a23c9e836975f842866a1fe101eb1a8d87258e24e88c11e45b1f7e80ebc40f90135d73dec18913e27c5359e048f80',
    __v: 0
}

db.createCollection('subscribers');

ue = {
    ambr: { downlink: { value: 1, unit: 3 }, uplink: { value: 1, unit: 3 } },
    schema_version: 1,
    msisdn: [],
    imeisv: '4370816125816151',
    mme_host: [],
    mme_realm: [],
    purge_flag: [],
    access_restriction_data: 32,
    subscriber_status: 0,
    operator_determined_barring: 0,
    network_access_mode: 0,
    subscribed_rau_tau_timer: 12,
    imsi: '999700000000001',
    security: {
    k: '465B5CE8B199B49FAA5F0A2EE238A6BC',
    amf: '8000',
    op: null,
    opc: 'E8ED289DEBA952E4283B54E88E6183CA',
    sqn: Long('3297')
    },
    slice: [
    {
        sst: 1,
        default_indicator: true,
        session: [
        {
            qos: {
            arp: {
                priority_level: 8,
                pre_emption_capability: 1,
                pre_emption_vulnerability: 1
            },
            index: 9
            },
            ambr: {
            downlink: { value: 1, unit: 3 },
            uplink: { value: 1, unit: 3 }
            },
            name: 'internet',
            type: 1,
            pcc_rule: []
        }
        ]
    }
    ],
    __v: 0
}

for (let i = 0; i < 3; i++) {
    db.subscribers.insertOne(ue)
    ue.imsi = "" + (parseInt(ue.imsi)+1)
}