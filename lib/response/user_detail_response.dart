import '../models/user_deatil_model.dart';

class UserDetailResponse {
  UserDeatilModel userDeatilModel;
  UserDetailResponse.fromJson(Map<String, dynamic> json) {
    userDeatilModel = UserDeatilModel();
    userDeatilModel.errorStatus = json['errorStatus'];
    userDeatilModel.message = json['message'];

    List<FAQ> faqs = List<FAQ>();

    if (json['data'] != '') {
      json['data']['userDeatils'].forEach((v) {
        userDeatilModel.userDeatil = parseData(v);
      });
    }

    if (json['data']['faqDetails'] != '') {
      json['data']['faqDetails'].forEach((v) {
        faqs.add(parsefaqs(v));
      });
      userDeatilModel.faqs = faqs;
    }

    if (json['data']['settingData'] != '') {
      json['data']['settingData'].forEach((v) {
        userDeatilModel.termsCodition = parseTermsCodition(v);
        userDeatilModel.contactDetail = parseContactDetail(v);
      });
    }
  }

  UserDeatil parseData(v) {
    UserDeatil userDeatil = UserDeatil();
    userDeatil.email = v['user_email'];
    userDeatil.name = v['user_name'];
    userDeatil.imageUrl = v['user_image'];
    userDeatil.mobile = v['user_phone'].toString();
    return userDeatil;
  }

  FAQ parsefaqs(v) {
    FAQ faq = FAQ();
    faq.faqQuestion = v['faq_question'];
    faq.fqaAnswer = v['faq_answer'];
    return faq;
  }

  TermsCodition parseTermsCodition(v) {
    TermsCodition termsCodition = TermsCodition();
    termsCodition.termsCoditionContent = v['app_privacy_policy'];
    return termsCodition;
  }

  ContactDetail parseContactDetail(v) {
    ContactDetail contactDetail = ContactDetail();
    contactDetail.email = v['app_email'];
    contactDetail.phone = v['app_contact'];
    return contactDetail;
  }
}
