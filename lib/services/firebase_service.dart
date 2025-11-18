// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // Get current authenticated user
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // ============ AUTH METHODS ============

  /// Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  /// Create account with email and password
  Future<UserCredential?> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // ============ USER PROFILE METHODS ============

  /// Create user profile in Firestore when account is created
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? profileImage,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': '',
        'profileImages': profileImage != null ? [profileImage] : [],
        'photoURL': profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'bio': '',
        'age': '',
        'height': '',
        'sexuality': [],
        'gender': [],
        'pronouns': [],
        'relationship_status': '',
        'relationship_style': '',
        'expectations': '',
        'expression': [],
        'interests': [],
        'sexual_pref': [],
        'lat': 0.0,
        'long': 0.0,
        'isProfileComplete': false,
        'searchVisibility': true,
        'blockedUsers': [],
      });
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Update user profile with new data
  Future<void> updateUserProfile({
    required Map<String, dynamic> data,
  }) async {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(currentUserId).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Get user profile by UID (single fetch)
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  /// Stream of current user profile (real-time updates)
  Stream<DocumentSnapshot> getCurrentUserProfileStream() {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    return _firestore.collection('users').doc(currentUserId).snapshots();
  }

  /// Get all users as a stream
  Stream<QuerySnapshot> getAllUsers() {
    return _firestore
        .collection('users')
        .snapshots();
  }

  /// Update user location
  Future<void> updateUserLocation(double latitude, double longitude) async {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'lat': latitude,
        'long': longitude,
      });
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  /// Mark profile as complete
  Future<void> markProfileComplete() async {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'isProfileComplete': true,
      });
    } catch (e) {
      throw Exception('Failed to mark profile complete: $e');
    }
  }

  // ============ CHAT METHODS ============

  /// Get or create a chat between two users
  Future<String> getOrCreateChat(String recipientUid) async {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    final participants = [currentUserId!, recipientUid]..sort();

    try {
      final existing = await _firestore
          .collection('chats')
          .where('participants', isEqualTo: participants)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return existing.docs.first.id;
      }

      final newChat = await _firestore.collection('chats').add({
        'participants': participants,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newChat.id;
    } catch (e) {
      throw Exception('Failed to get or create chat: $e');
    }
  }

  /// Get all chats for current user as a stream
  Stream<QuerySnapshot> getUserChatsStream() {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    print('Fetching chats for user: $currentUserId');
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }

  /// Get messages from a chat as a stream
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  /// Send a message to a chat
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    try {
      final messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set({
        'authorId': currentUserId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Load previous messages from a chat (pagination)
  Future<QuerySnapshot> loadPreviousMessages({
    required String chatId,
    required int limit,
  }) async {
    try {
      return await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  // ============ UTILITY METHODS ============

  /// Check if user is authenticated
  bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Get auth state changes as a stream
  Stream<User?> getAuthStateChanges() {
    return _auth.authStateChanges();
  }
}