# openlark

openlark is an app can open 'lark' for daily check-in conveniently with several idea. Just for fun  ;-)

😅😆😋😝😜😎🤡😏🤔😳😱





# Target Goal

* [ ] local config
  * [ ] monday - friday check-in time should before 10:00 am
* [ ] scheduled config
  * [x] new config with real and valid work day list (such as publish by HR)

* [ ] Remote config
  * [ ] fetch config from server through `network response`
    * [ ] request client such as alamofire
    * [ ] server such as github.com
    * [ ] Notice
      * [ ] iPhone may need to across the GFW to access  github.com
      * [ ] may be gitlab.com gitee.com are backup config
  * [ ] fetch config from iCloud
    * [ ] need login to the phone with a apple account
      * [ ] It's best to create a new account
    * [ ] enable iCloud
      * [ ] remember to turn off  sync switchs that useless, such as photos, find my phone and so on
    * [ ] put an json file to icloud with scheduled check-in time list
    * [ ] (read) - openlark load json as dataSource from icloud
    * [ ] (write) - openlark save check-in result file
    * [ ] (sync) - the check-in result json file  will sync automatic (upload) within (under) smooth network environment

