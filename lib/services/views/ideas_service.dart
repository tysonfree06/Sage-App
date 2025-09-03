import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/ideas_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/splash_services.dart';
import 'package:sage/services/views/subscription_services.dart';
import 'package:sage/view/ideas/widgets/idea_sheet.dart';

class IdeasServices {
  final _ideasRepository = IdeasRepository();
  final sessionController = SessionController();
  //gotoMyAddedIdeas
  static Future<void> gotoMyAddedIdeas(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.myAddedIdeas,
    );
  }

  //gotoAddIdea
  static Future<void> gotoAddIdea(
    BuildContext context, {
    bool isEditIdea = false,
    Map<String, dynamic>? ideaDetails,
  }) async {
    await Navigator.pushNamed(
      context,
      RoutesName.addIdea,
      arguments: {
        'isEditIdea': isEditIdea,
        'ideaDetails': ideaDetails,
      },
    );
  }

  //gotoIdeaDetails
  static Future<void> gotoIdeaDetails(
    BuildContext context, {
    required bool isAddedIdea,
    required Map<String, dynamic>? ideaDetails,
    bool callBackFlag = true,
  }) async {
    await Navigator.pushNamed(
      context,
      RoutesName.ideaDetails,
      arguments: {
        'isAddedIdeaScreen': isAddedIdea,
        'ideaDetails': ideaDetails,
      },
    );
  }

  //showBottomSheet
  static void showIdeaSheet(
    BuildContext context,
    String ideaId,
    VoidCallback? onBookmarkPressed,
    VoidCallback? onDislikePressed, {
    bool isBookmarked = false,
  }) {
    MyBottomSheet.show<void>(
      context,
      child: IdeaSheet(
        isBookmarked: isBookmarked,
        ideaId: ideaId,
        onBookmarkOrDislikePressedInSheet: () {
          onBookmarkPressed?.call();
        },
      ),
    );
  }

  static Widget buildIdeaDetailsAppBar(
    BuildContext context, {
    bool isAddedIdea = false,
    Map<String, dynamic>? ideaDetails,
    VoidCallback? onIdeaDeletePressed,
    VoidCallback? onIdeaEdited,
  }) {
    String title;
    if (isAddedIdea) {
      title = 'Added Ideas Details';
    } else {
      title = 'Ideas Details';
    }
    //isBookmarked
    final userId = SessionController().user?.id;
    final List<dynamic> savedBy =
        ideaDetails?['savedBy'] as List<dynamic>? ?? [];
    final bool isBookmarked = savedBy.contains(userId.toString());
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: BackButton(color: context.colors.mainGreenLight),
      actions: [
        if (isAddedIdea) ...[
          IconButton(
            onPressed: () {
              showDeleteIdeaDialog(
                context,
                onIdeaDeletePressed: () {
                  onIdeaDeletePressed?.call();
                },
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(), // optional
            ),
            icon: Assets.icons.deleteRed.svg(),
          ),
          SizedBox(
            width: 4.w,
          ),
          IconButton(
            onPressed: () async {
              await IdeasServices.gotoAddIdea(
                context,
                isEditIdea: true,
                ideaDetails: ideaDetails,
              );
              onIdeaEdited!.call();
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(), // optional
            ),
            icon: Assets.icons.edit.svg(color: context.colors.mainGreenLight),
          ),
          SizedBox(
            width: 16.w,
          ),
        ] else
          IconButton(
            onPressed: () {
              IdeasServices.showIdeaSheet(
                context,
                isBookmarked: isBookmarked,
                ideaDetails!['_id'].toString(),
                () {
                  Navigator.pop(context);
                },
                () {},
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(), // optional
            ),
            icon: Assets.icons.threeDots
                .svg(color: context.colors.mainGreenLight),
          ),
        SizedBox(
          width: 16.w,
        ),
      ],
    );
  }

  static Future<void> showDeleteIdeaDialog(
    BuildContext context, {
    VoidCallback? onIdeaDeletePressed,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        image: Assets.images.dialog.bin,
        titleFirst: context.l10n.dialog_delete,
        // titleSecond: context.l10n.dialog_account,
        titleSecond: 'Idea?',
        // subtitle: context.l10n.dialog_delete_account_subtitle,
        subtitle:
            'Are you sure you want to delete this idea?? it will be removed from everywhere..',

        confirmLabel: context.l10n.dialog_yes_delete,
        onConfirm: () async {
          onIdeaDeletePressed?.call();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  //API CALLS
  Future<dynamic> getFeed() async {
    try {
      final response = await _ideasRepository.getIdeasFeed();
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[RedeemService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[RedeemService] ❌ Unexpected: $e');
      }
    }
    return '';
  }

//is user is not premium/ not subscribed: show a dialog box
  static void showSubscriptionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        titleFirst: 'Subscription',
        titleSecond: ' Not Found',
        subtitle: 'You have to subscribe in order to use this feature!',
        confirmLabel: 'Subscribe',
        onConfirm: () {
          SubscriptionService.goToChangeSubscription(context);
        },
      ),
    );
  }

  //add idea Bookmark
  Future<void> addBookmark(
    BuildContext context,
    String ideaId,
  ) async {
    try {
      final responses = await Future.wait([
        _ideasRepository.addBookmark(ideaId),
        SplashServices().fetchProfile(context),
      ]);

      final response = responses.first as Map<String, dynamic>?;
      // final response = await _ideasRepository.addBookmark(ideaId);
      if (response != null) {
        if (context.mounted) {
          context.flushBarSuccessMessage(
            message: 'Idea saved successfully',
          );
        }
        debugPrint('Bookmark added successfully');
      }
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to add bookmark',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to save idea',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }

  Future<void> removeBookmark(
    BuildContext context,
    String ideaId,
  ) async {
    try {
      await _ideasRepository.removeBookmark(ideaId);
      if (context.mounted) {
        context.flushBarSuccessMessage(
          message: 'Bookmark removed successfully',
        );
      }
      debugPrint('Bookmark removed successfully');
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to remove bookmark',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to remove bookmark',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }

  Future<void> dislikeIdea(
    BuildContext context,
    String ideaId,
  ) async {
    try {
      await _ideasRepository.dislikeIdea(ideaId);
      if (context.mounted) {
        context.flushBarSuccessMessage(
          message: 'Ideas Disliked',
        );
      }
      debugPrint('Idea disliked successfully');
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to dislike idea',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to dislike idea',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }

  //get saved ideas
  Future<Map<String, dynamic>> getSavedIdeas(String type) async {
    try {
      final response = await _ideasRepository.getSavedIdeas(type);
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[RedeemService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[RedeemService] ❌ Unexpected: $e');
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> getAddedIdeas() async {
    try {
      final response = await _ideasRepository.getAddedIdeas();
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[RedeemService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[RedeemService] ❌ Unexpected: $e');
      }
    }
    return {};
  }

  //add new idea / add idea
  Future<void> uploadIdea(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await _ideasRepository.addIdea(data);
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (context.mounted) {
        context.flushBarSuccessMessage(
          message: 'Idea Added Successfully!',
        );
      }
      debugPrint('Idea added successfully');
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to add idea',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to add idea',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }

  //add new idea / add idea
  Future<void> editIdea(
    BuildContext context,
    String ideaId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _ideasRepository.updateIdea(ideaId, data);
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context); //two pops are necessary
        context.flushBarSuccessMessage(
          message: 'Idea Updated Successfully!',
        );
      }

      debugPrint('Idea updated successfully');
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to Update idea',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to update idea',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }

  //Delete Added Idea
  Future<void> deleteAddedIdea(
    BuildContext context,
    String ideaId,
  ) async {
    try {
      await _ideasRepository.deleteIdea(ideaId);
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (context.mounted) {
        context.flushBarSuccessMessage(
          message: 'Idea Deleted Successfully!',
        );
      }
      debugPrint('Idea deleted successfully');
    } catch (e) {
      if (e is AppException) {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to delete idea',
          );
        }
        debugPrint('[IdeasServices] ❌ ${e.debugMessage}');
      } else {
        if (context.mounted) {
          context.flushBarErrorMessage(
            message: 'Failed to delete idea',
          );
        }
        debugPrint('[IdeasServices] ❌ Unexpected: $e');
      }
    }
  }
}
