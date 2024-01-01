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

import { AppType } from '../model/AppInfo';
import { DataSource, ds_server } from '../data/DataSource';
import { HomePageData } from '../model/HomePageData';
import promptAction from '@ohos.promptAction';
import data_Preferences from '@ohos.data.preferences';
const ToastDuration = 2000
import featureAbility from '@ohos.ability.featureAbility'
import UIAbility from '@ohos.app.ability.UIAbility';
import common from '@ohos.app.ability.common'
import hilog from '@ohos.hilog';
import AppListItem from '../components/AppListItem';
import router from '@ohos.router';
import AppListItemVert from '../components/AppListItemVert';

let preferences = null;

@Component
export default struct Home{
  // 搜索
  private swiperController: SwiperController = new SwiperController()
  private controller: SearchController = new SearchController()
  @State changeValue: string = ''
  @State submitValue: string = ''

  // 应用收录
  @State totalCount: number = 0;
  @State appCount: number = 0;
  @State gameCount: number = 0;

  @State homePageData: HomePageData = new HomePageData({});
  private context = getContext(this) as common.UIAbilityContext
  aboutToAppear() {
    this.reload();
  }
  reload() {
    DataSource.getHomePageData((data) =>{
      this.homePageData = data;
    }, (err) => {
      promptAction.showToast({ message: '网路异常', duration: ToastDuration });
    });
  }
  @Builder NavigationTitle() {
    Column() {
      Text(this.homePageData.appName)
        .fontColor('#182431')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({left: -25})
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
          .hideBackButton(true)
          .backgroundColor("#f1f3f5")
//          .border({width: {bottom: 0.5}, color: '#c9c9c9'})
          .padding({left: 15, right: 15})

        Scroll() {
          Column() {
            Column() {

              Text(this.homePageData.announcement || HomePageData.defaultAnnouncement)
                .width('100%')
                .borderRadius(15)
                .backgroundColor('#f6f6f6')
                .padding(10)
                .fontSize(16)
                .fontColor('#555555')

            }.margin({top: 15}).visibility(this.homePageData.showAnnouncement ? Visibility.Visible : Visibility.None)
            // 搜索
            // Search({ value: this.changeValue, placeholder: '应用、游戏...', controller: this.controller })
            //   .searchButton('搜索')
            //   .width('100%')
            //   .height(40)
            //   .backgroundColor('#F5F5F5')
            //   .placeholderColor(Color.Grey)
            //   .placeholderFont({ size: 14, weight: 400 })
            //   .textFont({ size: 14, weight: 400 })
            //   .onSubmit((value: string) => {
            //     promptAction.showToast({ message: '应用太少，无需搜索！', duration: ToastDuration });
            //   })
            //   .onChange((value: string) => {
            //   })
            //   .focusable(false)

            // 滚动图
            Swiper(this.swiperController) {
             ForEach(this.homePageData.slideshow,(item,index)=>{
               Image(item).width('100%').height(150).borderRadius(15)
             })
            }
            .cachedCount(3)
            .index(0)
            .autoPlay(true)
            .interval(5000)
            .indicator(true)
            .loop(true)
            .duration(1000)
            .itemSpace(20)
            .curve(Curve.Linear)
            .onChange((index: number) => {
              console.info(index.toString())
            })
            .margin({top: 10})
            // 最新公告

            List(){
              ForEach(this.homePageData.sections,(item,index)=>{
                ListItem(){
                  if (index % 2 == 0){
                    Column(){
                      Text(item["name"])
                        .fontSize(27)
                        .fontWeight(FontWeight.Bold)
                        .margin({bottom:10,top:10})
                        .textAlign(TextAlign.Start)
                      ForEach(item["apps"],(item2,index2)=>{
                        AppListItem({appInfo: item2})
                        Divider()
                          .strokeWidth(0.5)
                          .color("#d6d6d6")
                          .margin({left:75})
                      })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .padding({ left:10, right:15,bottom:10 })

                  }
                  else{
                    Column(){
                      Text(item["name"])
                        .fontSize(27)
                        .fontWeight(FontWeight.Bold)
                        .margin({bottom:10,top:10})
                        .textAlign(TextAlign.Start)
                      Scroll(){
                        Row(){
                          ForEach(item["apps"],(item2,index2)=>{
                            AppListItemVert({appInfo: item2})

                          })
                        }
                      }
                    }
                    .width("100%")
                    .alignItems(HorizontalAlign.Start)
                    .padding({ left:10, right:15 })
                    .margin({bottom:20})
                  }
                }
                .onClick(()=>{
                  router.pushUrl({ url: 'pages/CardDetails', params: {appList:item["apps"],cardName:item["name"]} });
                })
                .margin({bottom:20})
                .borderRadius(25)
                .backgroundColor("white")
              })
            }
            .padding(10)
          }
          .width('100%')
          .padding({left: 10, right: 10})
        }
        .backgroundColor("#f1f3f5")
        .edgeEffect(EdgeEffect.None)
        .width('100%')
        .height('auto')
        .margin({bottom: 56})
      }
      .width('100%')
      .height('100%')
    }.width('100%').height('100%').backgroundColor('#f1f3f5')
  }
}