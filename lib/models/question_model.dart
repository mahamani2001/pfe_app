class QuestionModel {
  final String question;
  List<String> options;
  String userAnswered;

  QuestionModel({
    required this.question,
    required this.options,
    this.userAnswered = "",
  });
}

List<QuestionModel> questions = [
  QuestionModel(
      question:
          "Vous êtes-vous senti(e) nerveux(se) ou anxieux(se) sans raison particulière ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question:
          "Avez-vous eu du mal à contrôler vos inquiétudes ou à les arrêter ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question: "Avez-vous souvent trop de pensées stressantes ou négatives ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question: "Vos pensées deviennent-elles parfois catastrophiques ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question:
          "Avez-vous eu l’impression que quelque chose de grave allait arriver sans explication ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question:
          "Avez-vous ressenti des tensions musculaires ou des douleurs inexpliquées ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question: "Votre cœur s’est-il mis à battre rapidement ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question:
          "Avez-vous eu des difficultés à respirer sans raison médicale connue ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question: "Avez-vous déjà eu du mal à dormir à cause de vos pensées ?",
      options: ["Jamais", "Parfois", "Souvent", "Toujours"]),
  QuestionModel(
      question:
          "Avez-vous ressenti des maux de tête fréquents liés au stress ?",
      options: ["Pas du tout", "Moyennement", "Légèrement", "Beaucoup"]),
  QuestionModel(
      question:
          "Votre anxiété vous empêche-t-elle d’accomplir vos tâches quotidiennes ?",
      options: ["Pas du tout", "Moyennement", "Légèrement", "Beaucoup"]),
  QuestionModel(
      question:
          "Avez-vous évité certaines situations sociales par peur du jugement ou de l’inconfort ?",
      options: ["Pas du tout", "Moyennement", "Légèrement", "Beaucoup"]),
  QuestionModel(
      question:
          "Avez-vous ressenti une perte de motivation pour des activités que vous aimiez ?",
      options: ["Pas du tout", "Moyennement", "Légèrement", "Beaucoup"]),
  QuestionModel(
      question:
          "Avez-vous eu des difficultés à vous concentrer à cause de vos pensées ?",
      options: ["Pas du tout", "Moyennement", "Légèrement", "Beaucoup"]),
  QuestionModel(
      question:
          "Tu peux exprimer librement tes inquiétudes .😊Y a-t-il un élément précis qui te stresse actuellement ?  ",
      options: ["", "", "", ""]),
];
