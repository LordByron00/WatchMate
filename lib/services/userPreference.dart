import 'package:WatchMate/utils/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceService {
  // static final PreferenceService Preference = PreferenceService._internal();

  // // Private constructor
  // PreferenceService._internal();

  // // Factory constructor to return the singleton instance
  // factory PreferenceService() {
  //   return Preference;
  // }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var curUserID = Auth().curUserData?.uid;

  Future<void> addFavorite(Map<String, dynamic> movie) async {
    await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('favorite')
        .doc()
        .set(movie);
  }

  Future<void> addRating(Map<String, dynamic> movie) async {
    await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('rating')
        .doc()
        .set(movie);
  }

  Future<void> addReview(Map<String, dynamic> movie) async {
    await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .doc()
        .set(movie);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFavorites(user) async {
    print('curUserID');
    print(user);
    return await _firebaseFirestore
        .collection('users')
        .doc(user)
        .collection('favorite')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRatings(user) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(user)
        .collection('rating')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReviews(user) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(user)
        .collection('review')
        .get();
  }
}
