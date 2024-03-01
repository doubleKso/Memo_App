
class Notes{
  final int? noteId;
  final String noteTitle;
  final String noteContent;
  final int? noteStatus;
  final String? category;
  final String? createdAt;
  Notes({this.noteId, required this.noteTitle, required this.noteContent, this.noteStatus = 1,this.category,this.createdAt});

  factory Notes.fromMap(Map<String, dynamic> json) => Notes(
    noteId: json['noteId'],
    noteTitle: json ['noteTitle'],
    noteContent: json['noteContent'],
    noteStatus: json['noteStatus'],
    category: json['category'],
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toMap(){
    return{
      'noteId':noteId,
      'noteTitle': noteTitle,
      'noteContent':noteContent,
      'noteStatus':noteStatus,
      'category':category,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

}