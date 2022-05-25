import 'package:tamka/models/book_model.dart';
import 'package:tamka/models/single_post_model.dart';

List<PostModel> getBooks(){

  List<PostModel> books = [];
  PostModel bookModel  = new PostModel();

  //1
  bookModel.imgAssetPath = "assets/mermaid.jpg";
  bookModel.title = "HIV Stigma and Discrimination";
  bookModel.description = '''“Stigma and discrimination are major challenges facing People Living with HIV/AIDS (PLWHA) globally due to their HIV status.''';
  bookModel.rating = 3;
  bookModel.categorie = "Article";
  books.add(bookModel);
  bookModel = new PostModel();

  //1
  bookModel.imgAssetPath = "assets/download.jpg";
  bookModel.title = "Willows Of Fate";
  bookModel.description = '''Stigma and discrimination are major challenges facing People Living with HIV/AIDS (PLWHA) 
  globally due to their HIV status (1, 2).''';
  bookModel.rating = 4;
  bookModel.categorie = "Paper";

  books.add(bookModel);
  bookModel = new PostModel();

  return books;
}

List<SinglePostModel> getSingleBooks(){

  List<SinglePostModel> books = [];
  SinglePostModel singleBookModel = new SinglePostModel();

  //1
  singleBookModel.imgAssetPath = "assets/six_crows.png";
  singleBookModel.title = "Siz of crows";
  singleBookModel.categorie = "Classic";
  books.add(singleBookModel);

  singleBookModel = new SinglePostModel();


  //2
  singleBookModel.imgAssetPath = "assets/time_of_witches.png";
  singleBookModel.title = "Tim of Witched";
  singleBookModel.categorie = "Anthology";
  books.add(singleBookModel);

  singleBookModel = new SinglePostModel();


  //3
  singleBookModel.imgAssetPath = "assets/infinite_future.png";
  singleBookModel.title = "Infinite futures";
  singleBookModel.categorie = "Mystery";
  books.add(singleBookModel);

  singleBookModel = new SinglePostModel();


  //4
  singleBookModel.imgAssetPath = "assets/junot_diaz.png";
  singleBookModel.title = "Sun the moon";
  singleBookModel.categorie = "Romance";
  books.add(singleBookModel);

  singleBookModel = new SinglePostModel();


  //1
  singleBookModel.imgAssetPath = "assets/dancing_with_the_tiger.png";
  singleBookModel.title = "Dancing with Tiger";
  singleBookModel.categorie = "Comic";
  books.add(singleBookModel);

  singleBookModel = new SinglePostModel();

  return books;

}