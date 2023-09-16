String validateTitle(String txt){
  if(txt.isEmpty){
    return "Title vui lòng không được để trống!";
  }
  return "";
}

String validateDescribe(String txt){
  if(txt.isEmpty){
    return "Describe vui lòng không được để trống!";
  }
  return "";
}