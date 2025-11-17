class CommonParam {
  int? provinceId;
  int? districtId;
  int page;
  int limit;
  bool loadPage;
  int? startTime;
  int? endTime;

  CommonParam({
    this.provinceId,
    this.districtId,
    this.page = 1,
    this.limit = 10,
    this.loadPage = true,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   if(provinceId != null) data['province_id'] = provinceId;
    if(districtId != null) data['district_id'] = districtId;
    if(loadPage) data['page'] = page;
    if(loadPage) data['limit'] = limit;
    if(startTime != null) data['start_time'] = startTime;
    if(endTime != null) data['end_time'] = endTime;
    return data;
  }
}