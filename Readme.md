Rbtwist
======
This Gem provides Object-Oriented access to HP Server Automation's SOAP API

Rbtwist was created to allow interacting with the Opsware API via the SOAP WS interface.

Rbtwist abstracts the SOAP communication behind the scenes and speaks in plain Ruby Objects.

**NOTE: The code is provided as-is. It is in early stages and has yet to be fully tested in all scenarios. Use at your own risk**

Config
--------
###Setup

Basic configuration is done via 'config/rbtwist.yml'
This file is parsed by ERB and YAML, so you can call methods or reference environment variables. 
* Versions supported are 9.1, 10.2
* Utilize primary slice and port 443 (This ensures calls are balanced between all slices)
* Port 4433 can be used to force all Twist calls to be executed on a particular slice.

*(Interactive setup is coming soon)*
####Sample YML File

```yaml
hpsa_prod: &hpsa_prod
  server: 10.2.2.10
  user: <%= ENV['SA_USER'] %>
  password: <%= ENV['SA_PASSWORD'] %>
  version: 9.1
  port: 443

hpsa_lab: &hpsa_lab
  server: 10.4.4.4
  user: detuser
  password: mycomplexpassword
  version: 10.2
  port: 443

production: *hpsa_prod
development: *hpsa_prod
```

### Examples
See some basic code under 'dev/dev_utils.rb'
More example will be added soon.

> ####Search for Servers
> ```
> todorovd :todorovd-mbp in /opt/rubydev/gems/rbtwist
$ irb -r './lib/rbtwist'
2.1.3 :001 > Opsware=Rbtwist::Opsware
 => Rbtwist::Opsware
2.1.3 :002 > server_service=Opsware.ServerService(Rbtwist.get_connection)
 => #<Rbtwist::Opsware::ServerService:0x007ff179720520 @connection=<Opsware Connection(User: someuser, Host: prod.hpsa.some.domain.com:4433) 70337586313680>>
2.1.3 :003 > filter=Opsware.Filter(expression: 'ServerVO.hostName CONTAINS SOMEHOSTNAME')
 => #<Rbtwist::Opsware::Filter:0x007ff179730218 @props={:expression=>"ServerVO.hostName CONTAINS SOMEHOSTNAME"}>
2.1.3 :004 > server_refs=server_service.findServerRefs(filter: filter)
 => [#<Rbtwist::Opsware::ServerRef:0x007ff17db50cb8 @props={:id=>85200001, :idAsLong=>85200001, :name=>"SOMEHOSTNAME.some.domain.com", :secureResourceTypeName=>"device"}>]
2.1.3 :005 > server_vo=server_service.getServerVO(self: server_refs.first)
 => #<Rbtwist::Opsware::ServerVO:0x007ff17dbd1bb0 @props={:ref=>#<Rbtwist::Opsware::ServerRef:0x007ff17dbda558 @props={:id=>85200001, :idAsLong=>85200001, :name=>"SOMEHOSTNAME.some.domain.com", :secureResourceTypeName=>"device"}>, :createdBy=>"Automatic", :createdDate=>2015-01-13 12:25:08 UTC, :dirtyAttributes=>[], :logChange=>true, :modifiedBy=>"someuser", :modifiedDate=>2015-01-18 18:11:51 UTC, :description=>"HERKL", :hostName=>"SOMEHOSTNAME.some.domain.com", :manufacturer=>"HEWLETT-PACKARD", :model=>"HP Z820 WORKSTATION", :osVersion=>"Microsoft Windows Server 2012 R2 Standard x64  Build 9600 (09-16-2014)", :primaryIP=>"10.2.2.242", :serialNumber=>"SOMESERIAL", :agentVersion=>"45.0.47353.0", :codeset=>"CP1252", :customer=>#<Rbtwist::Opsware::CustomerRef:0x007ff17bd7c958 @props={:id=>9, :idAsLong=>9, :name=>"Not Assigned", :secureResourceTypeName=>"customer"}>, :defaultGw=>"10.2.2.1", :discoveredDate=>2015-01-13 12:25:08 UTC, :facility=>#<Rbtwist::Opsware::FacilityRef:0x007ff17bd95a48 @props={:id=>10001, :idAsLong=>10001, :name=>"SOMEFACILITY", :secureResourceTypeName=>"facility"}>, :firstDetectDate=>nil, :hypervisor=>false, :lastScanDate=>nil, :locale=>"1033", :lockInfo=>#<Rbtwist::Opsware::LockInfo:0x007ff17bdb5cf8 @props={:comment=>nil, :date=>nil, :locked=>false, :user=>nil}>, :loopbackIP=>nil, :managementIP=>"10.2.2.242", :mid=>"85200001", :name=>"SOMEHOSTNAME.some.domain.com", :netBIOSName=>nil, :opswLifecycle=>"MANAGED", :origin=>"ASSIMILATED", :osFlavor=>"Windows Server 2012 R2 Standard x64", :osSPVersion=>"RTM", :peerIP=>"10.2.2.242", :platform=>#<Rbtwist::Opsware::PlatformRef:0x007ff17bdf7ea0 @props={:id=>95000, :idAsLong=>95000, :name=>"Windows Server 2012 R2 x64"}>, :previousSWRegDate=>2015-01-20 19:25:41 UTC, :realm=>#<Rbtwist::Opsware::RealmRef:0x007ff17bdfc298 @props={:id=>50001, :idAsLong=>50001, :name=>"SOMEFACILITY", :secureResourceTypeName=>"realm"}>, :rebootRequired=>false, :reporting=>true, :stage=>"UNKNOWN", :state=>"OK", :use=>"UNKNOWN", :virtualizationType=>-1}>
2.1.3 :006 > pp server_vo
ServerVO(
  agentVersion: "45.0.47353.0",
  codeset: "CP1252",
  createdBy: "Automatic",
  createdDate: 2015-01-13 12:25:08 UTC,
  customer: CustomerRef(
    id: 9,
    idAsLong: 9,
    name: "Not Assigned",
    secureResourceTypeName: "customer"
  ),
  defaultGw: "10.2.2.1",
  description: "HERKL",
  dirtyAttributes: [],
  discoveredDate: 2015-01-13 12:25:08 UTC,
  facility: FacilityRef(
    id: 10001,
    idAsLong: 10001,
    name: "SOMEFACILITY",
    secureResourceTypeName: "facility"
  ),
  firstDetectDate: nil,
  hostName: "SOMEHOSTNAME.some.domain.com",
  hypervisor: false,
  lastScanDate: nil,
  locale: "1033",
  lockInfo: LockInfo( comment: nil, date: nil, locked: false, user: nil ),
  logChange: true,
  loopbackIP: nil,
  managementIP: "10.2.2.242",
  manufacturer: "HEWLETT-PACKARD",
  mid: "85200001",
  model: "HP Z820 WORKSTATION",
  modifiedBy: "someuser",
  modifiedDate: 2015-01-18 18:11:51 UTC,
  name: "SOMEHOSTNAME.some.domain.com",
  netBIOSName: nil,
  opswLifecycle: "MANAGED",
  origin: "ASSIMILATED",
  osFlavor: "Windows Server 2012 R2 Standard x64",
  osSPVersion: "RTM",
  osVersion: "Microsoft Windows Server 2012 R2 Standard x64  Build 9600 (09-16-2014)",
  peerIP: "10.2.2.242",
  platform: PlatformRef(
    id: 95000,
    idAsLong: 95000,
    name: "Windows Server 2012 R2 x64"
  ),
  previousSWRegDate: 2015-01-20 19:25:41 UTC,
  primaryIP: "10.2.2.242",
  realm: RealmRef(
    id: 50001,
    idAsLong: 50001,
    name: "SOMEFACILITY",
    secureResourceTypeName: "realm"
  ),
  rebootRequired: false,
  ref: ServerRef(
    id: 85200001,
    idAsLong: 85200001,
    name: "SOMEHOSTNAME.some.domain.com",
    secureResourceTypeName: "device"
  ),
  reporting: true,
  serialNumber: "SOMESERIAL",
  stage: "UNKNOWN",
  state: "OK",
  use: "UNKNOWN",
  virtualizationType: -1
)
 => #<Rbtwist::Opsware::ServerVO:0x007ff17dbd1bb0 @props={:ref=>#<Rbtwist::Opsware::ServerRef:0x007ff17dbda558 @props={:id=>85200001, :idAsLong=>85200001, :name=>"SOMEHOSTNAME.some.domain.com", :secureResourceTypeName=>"device"}>, :createdBy=>"Automatic", :createdDate=>2015-01-13 12:25:08 UTC, :dirtyAttributes=>[], :logChange=>true, :modifiedBy=>"someuser", :modifiedDate=>2015-01-18 18:11:51 UTC, :description=>"HERKL", :hostName=>"SOMEHOSTNAME.some.domain.com", :manufacturer=>"HEWLETT-PACKARD", :model=>"HP Z820 WORKSTATION", :osVersion=>"Microsoft Windows Server 2012 R2 Standard x64  Build 9600 (09-16-2014)", :primaryIP=>"10.2.2.242", :serialNumber=>"SOMESERIAL", :agentVersion=>"45.0.47353.0", :codeset=>"CP1252", :customer=>#<Rbtwist::Opsware::CustomerRef:0x007ff17bd7c958 @props={:id=>9, :idAsLong=>9, :name=>"Not Assigned", :secureResourceTypeName=>"customer"}>, :defaultGw=>"10.2.2.1", :discoveredDate=>2015-01-13 12:25:08 UTC, :facility=>#<Rbtwist::Opsware::FacilityRef:0x007ff17bd95a48 @props={:id=>10001, :idAsLong=>10001, :name=>"SOMEFACILITY", :secureResourceTypeName=>"facility"}>, :firstDetectDate=>nil, :hypervisor=>false, :lastScanDate=>nil, :locale=>"1033", :lockInfo=>#<Rbtwist::Opsware::LockInfo:0x007ff17bdb5cf8 @props={:comment=>nil, :date=>nil, :locked=>false, :user=>nil}>, :loopbackIP=>nil, :managementIP=>"10.2.2.242", :mid=>"85200001", :name=>"SOMEHOSTNAME.some.domain.com", :netBIOSName=>nil, :opswLifecycle=>"MANAGED", :origin=>"ASSIMILATED", :osFlavor=>"Windows Server 2012 R2 Standard x64", :osSPVersion=>"RTM", :peerIP=>"10.2.2.242", :platform=>#<Rbtwist::Opsware::PlatformRef:0x007ff17bdf7ea0 @props={:id=>95000, :idAsLong=>95000, :name=>"Windows Server 2012 R2 x64"}>, :previousSWRegDate=>2015-01-20 19:25:41 UTC, :realm=>#<Rbtwist::Opsware::RealmRef:0x007ff17bdfc298 @props={:id=>50001, :idAsLong=>50001, :name=>"SOMEFACILITY", :secureResourceTypeName=>"realm"}>, :rebootRequired=>false, :reporting=>true, :stage=>"UNKNOWN", :state=>"OK", :use=>"UNKNOWN", :virtualizationType=>-1}>
2.1.3 :007 >
> ```
 
### Parse WSDL Files
Rbtwist relies on Type and Service definitions extracted from the Opsware WSDL files.
For speed purposes, this data is parsed once, then stored as a Marshalled hash on disk.
I provide two pre-parsed DBs of types in the paths below. Rbtwist looks for one of these two files depending on your version.
If you parse your own, simply replace the existing .db file with your output.
Version | File
---------|--------
9.1x|model_db/opsware_models_91.db
10.2x|model_db/opsware_models_102.db

#### Parse your own WSDL
The WSDL parsing functionality is self-contained within **Rbtwist::Wsdl** 'lib/rbtwist/wsdl'.
Parsing the WSDL files can take up to 20 minutes if running on a slow machine. 

The method for parsing WSDL files is:
```
Rbtwist.parse_remote_wsdls host,port,services=[]
```
Services is an optional array of Services to parse. If left empty, everything is parsed.
This allows for quicker testing without having to dump all WSDL files.

For example. The following will parse all WSDL files and create a file in the root
opsware_gen_[Timestamp].db
Replace the default db with the one generated.
```
todorovd :todorovd-mbp in /opt/rubydev/gems/rbtwist
$ irb
2.1.3 :001 > require './lib/rbtwist/wsdl'
 => true
2.1.3 :002 > Rbtwist::Wsdl.parse_remote_wsdls('10.2.2.4',443)
{:name=>"NasConnectionService",
 :download=>0.27771,
 :nokogiri_parse=>1.021665,
 :parse_schemas=>0.768926,
 :parse_service=>0.020168}{:name=>"SnapshotResultService",
 :download=>0.194853,
 :nokogiri_parse=>1.265921,
 :parse_schemas=>0.528522,
 :parse_service=>0.030344}
........
 => nil
2.1.3 :003 > exit

todorovd :todorovd-mbp in /opt/rubydev/gems/rbtwist
$ ls *.db
opsware_gen_1421863671.db
```


Specs
-------
**Ruby Versions Tested**
> - ruby 2.1.3
> - jruby 1.7.18

**HPSA (Opsware) Versions Tested**
> - SAS 9.16 Opsware API
> - SAS 10.20.000 Opsware API

Note: Minor versions should be interoperable with the same model DB. 
However, for better success, I suggest parsing the WSDLS yourself into a DB from your cores.


### Thanks
A lot of the SOAP communication and Type Loader code was borrowed from Rbvmomi.
[https://github.com/vmware/rbvmomi](https://github.com/vmware/rbvmomi)



* Still in ALPHA


Dimiter Todorov 2014