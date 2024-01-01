/*
 * Copyright (C) 2023 westinyang https://gitee.com/ohos-dev
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import {AppInfo, AppType} from '../model/AppInfo';
import AppListItem from '../components/AppListItem';
import { DataSource } from '../data/DataSource';
import router from '@ohos.router';
import common from '@ohos.app.ability.common'
import data_Preferences from '@ohos.data.preferences';
import installer from '@ohos.bundle.installer';
import promptAction from '@ohos.promptAction';
import fileio from '@ohos.fileio';
import picker from '@ohos.file.picker';
import dataShare from '@ohos.data.dataShare';
import UIAbility from '@ohos.app.ability.UIAbility';
import fileUri from '@ohos.file.fileuri';
@Component
@Entry
export default struct CardDetail {
  appType: AppType
  @State appList: AppInfo[] = router.getParams()['appList']
  @State cardName: string = router.getParams()['cardName']
  private context = getContext(this) as common.UIAbilityContext

  @Builder NavigationTitle() {
    Column() {
      Text(this.cardName)
        .fontColor('#182431')
        .fontSize(28)

    }.alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        // 页面标题
        Navigation()
          .title(this.NavigationTitle())
          .hideToolBar(true)
          .height(56)
          .width('100%')
          .titleMode(NavigationTitleMode.Mini)
          .hideBackButton(false)
          .padding({left: 15, right: 15})

        Scroll() {
          Column() {
            List({ space: 0, initialIndex: 0 }) {
              ForEach(this.appList, (item: AppInfo) => {
                ListItem() {
                  AppListItem({appInfo: new AppInfo(item)})
                }
              }, (item: AppInfo, index) => index + JSON.stringify(item))
            }

            .width('auto')
            .height('auto')
            .padding({left: 15, right: 15})
            .divider({
              strokeWidth: 0.5,
              color: '#d6d6d6',
              startMargin: 75,
              endMargin: 0
            })
          }
          .width('100%')
          //          .margin({top: 7.5, bottom: 7.5})
        }

        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height('auto')
        .margin({bottom: 56})
      }
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
  // 安装应用 或 更新应用
  async installApp(hapPath: string) {
    hapPath = fileUri.getUriFromPath(hapPath);
    let filePath = globalThis.abilityContext.filesDir + '/' + 'org.ohosdev.foh' + '-' + '1.0.0' + ".hap";
    promptAction.showDialog({
      title: 'Information',
      message: hapPath,
      buttons: [
        { text: 'OK', color: '#3478f6', }
      ],
    })
    fileio.copyFile(hapPath, filePath).then(function(){
      let hapFilePaths = [filePath];
      let installParam = {
        userId: 100,
        isKeepData: false,
        installFlag: 1,
      };

      try {

        installer.getBundleInstaller().then(data => {
          data.install(hapFilePaths, installParam, err => {
            if (err) {
              console.error('install failed:' + err.message);
              promptAction.showToast({ message: '失败'});
            } else {
              console.info('install successfully.');
              promptAction.showToast({ message: '成功'});
            }
          });
        }).catch(error => {
          promptAction.showToast({ message:'失败' });
        });
      } catch (error) {
        console.error('getBundleInstaller failed. Cause: ' + error.message);
        promptAction.showToast({ message: '失败'});
      }
    }).catch(function(err){
      console.info("copyFile failed with error:"+ err);
    });

  }
}
