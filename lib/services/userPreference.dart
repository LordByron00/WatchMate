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

  Future<bool> addFavorite(Map<String, dynamic> movie) async {
    try {
      QuerySnapshot MovieSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('favorite')
          .where('id', isEqualTo: movie['id'])
          .limit(1) // Look for the document with this id
          .get();

      if (MovieSnapshot.docs.isEmpty) {
        await _firebaseFirestore
            .collection('users')
            .doc(curUserID)
            .collection('favorite')
            .doc()
            .set(movie);
        return true;
      } else {
        String docId = MovieSnapshot.docs.first.id;
        await _firebaseFirestore
            .collection('users')
            .doc(curUserID)
            .collection('favorite')
            .doc(docId)
            .delete();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> addRating(Map<String, dynamic> movie) async {
    QuerySnapshot ratingMovie = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('rating')
        .where('id', isEqualTo: movie['id'])
        .get();
    if (ratingMovie.docs.isEmpty) {
      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('rating')
          .doc()
          .set(movie);
    } else {
      String ratingID = ratingMovie.docs.first.id;

      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('rating')
          .doc(ratingID)
          .update(movie);
    }
  }

  Future<void> addReview(Map<String, dynamic> movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .limit(1)
        .get();

    if (reviewSnap.docs.isNotEmpty) {
      String MovieDocID = reviewSnap.docs.first.id;
      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('review')
          .doc(MovieDocID)
          .update(movie);
    } else {
      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('review')
          .doc()
          .set(movie);
    }
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

  Future<QuerySnapshot<Object?>> checkReview(movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .where('review', isNotEqualTo: null)
        .limit(1)
        .get();

    return reviewSnap;
  }

  Future<QuerySnapshot<Object?>> checkRating(movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .where('rating', isGreaterThanOrEqualTo: 1)
        .limit(1)
        .get();

    return reviewSnap;
  }

  Future<bool> checkReviewStatus(movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .where('review', isNotEqualTo: null)
        .limit(1)
        .get();
    if (reviewSnap.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkRatingStatus(movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .where('rating', isGreaterThanOrEqualTo: 1)
        .limit(1)
        .get();

    print('reviewSnap');
    print(reviewSnap);
    if (reviewSnap.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkFavorite(Map<String, dynamic> movie) async {
    try {
      QuerySnapshot MovieSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('favorite')
          .where('id', isEqualTo: movie['id'])
          .limit(1) // Look for the document with this id
          .get();

      if (MovieSnapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> clearReview(movie) async {
    QuerySnapshot reviewSnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .limit(1)
        .get();

    if (reviewSnap.docs.isNotEmpty) {
      String reviewID = reviewSnap.docs.first.id;
      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('review')
          .doc(reviewID)
          .delete();
    }
  }

  Future<void> clearRating(movie) async {
    QuerySnapshot ratingsnap = await _firebaseFirestore
        .collection('users')
        .doc(curUserID)
        .collection('review')
        .where('id', isEqualTo: movie['id'])
        .where('rating', isNotEqualTo: null)
        .limit(1)
        .get();

    if (ratingsnap.docs.isNotEmpty) {
      String ratingID = ratingsnap.docs.first.id;
      await _firebaseFirestore
          .collection('users')
          .doc(curUserID)
          .collection('review')
          .doc(ratingID)
          .update({'rating': 0});
    }
  }
}
