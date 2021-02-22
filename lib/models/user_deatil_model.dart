class UserDeatilModel {
  bool errorStatus;
  String message;
  UserDeatil userDeatil;
  List<FAQ> faqs;
  ContactDetail contactDetail;
  TermsCodition termsCodition;
}

class UserDeatil {
  String name;
  String email;
  String imageUrl;
  String mobile;
}

class FAQ {
  String faqQuestion;
  String fqaAnswer;
}

class ContactDetail {
  String email;
  int phone;
}

class TermsCodition {
  String termsCoditionContent;
}
