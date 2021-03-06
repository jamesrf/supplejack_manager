# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

@PreviewJobsPoller =
  poll: ->
    if @lock == false || @lock == undefined
      @lock = true
      setTimeout @request, 2000 

  request: ->
    PreviewJobsPoller.lock = false
    $.get($("#preview-job").attr('url') + ".js")