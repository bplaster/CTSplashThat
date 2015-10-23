// Generated by Apple Swift version 2.0 (swiftlang-700.0.59 clang-700.0.72)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;
@class NSData;
@class NSError;

SWIFT_CLASS("_TtC8MamaBear11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (void)application:(UIApplication * __nonnull)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData * __nonnull)deviceToken;
- (void)application:(UIApplication * __nonnull)application didFailToRegisterForRemoteNotificationsWithError:(NSError * __nonnull)error;
- (void)application:(UIApplication * __nonnull)application didReceiveRemoteNotification:(NSDictionary * __nonnull)userInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class PFObject;
@class NSIndexPath;
@class NSCoder;
@class UITableViewCell;

SWIFT_CLASS("_TtC8MamaBear10AssignView")
@interface AssignView : UIView <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView * __null_unspecified assigneeTableView;
@property (nonatomic, copy) NSArray<PFObject *> * __nonnull staffList;
@property (nonatomic, copy) NSString * __null_unspecified objectID;
@property (nonatomic) NSIndexPath * __null_unspecified indexPath;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (void)bringUp:(NSIndexPath * __nullable)index;
- (void)putDown;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (NSInteger)numberOfSectionsInTableView:(UITableView * __nonnull)tableView;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
@end

@class UITextField;
@class NSBundle;

SWIFT_CLASS("_TtC8MamaBear19LoginViewController")
@interface LoginViewController : UIViewController
@property (nonatomic) IBOutlet UITextField * __null_unspecified usernameTextField;
@property (nonatomic) IBOutlet UITextField * __null_unspecified userTypeTextField;
- (void)viewDidLoad;
- (IBAction)enterButtonPressed:(id __nonnull)sender;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UIImageView;
@class UIButton;
@class UIColor;

SWIFT_CLASS("_TtC8MamaBear17TaskTableViewCell")
@interface TaskTableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel * __null_unspecified titleLabel;
@property (nonatomic) IBOutlet UILabel * __null_unspecified descLabel;
@property (nonatomic) IBOutlet UIImageView * __null_unspecified typeImageView;
@property (nonatomic) IBOutlet UILabel * __null_unspecified creatorLabel;
@property (nonatomic) IBOutlet UIView * __null_unspecified infoView;
@property (nonatomic) IBOutlet UIView * __null_unspecified headerView;
@property (nonatomic) UIButton * __null_unspecified assignButton;
@property (nonatomic) UIButton * __null_unspecified acceptButton;
@property (nonatomic) UIButton * __null_unspecified completeButton;
@property (nonatomic) IBOutlet UIButton * __null_unspecified primaryButton;
@property (nonatomic) UIColor * __nonnull red;
@property (nonatomic) UIColor * __nonnull orange;
@property (nonatomic) UIColor * __nonnull green;
@property (nonatomic) UIColor * __nonnull blue;
@property (nonatomic) UIColor * __nonnull grey;
@property (nonatomic, copy) NSString * __null_unspecified accepted;
@property (nonatomic, copy) NSString * __null_unspecified assigned;
@property (nonatomic, copy) NSString * __null_unspecified assignee;
@property (nonatomic, copy) NSString * __null_unspecified completed;
@property (nonatomic, copy) NSString * __null_unspecified objectID;
@property (nonatomic) NSIndexPath * __null_unspecified index;
- (void)awakeFromNib;
- (void)assignButtonPressed;
- (void)acceptButtonPressed;
- (void)completeButtonPressed;
- (void)customizeCell:(NSString * __nonnull)type;
- (void)populateCell:(PFObject * __nonnull)ticket currentUser:(NSString * __nonnull)currentUser;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * __nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSTimer;

SWIFT_CLASS("_TtC8MamaBear24TicketListViewController")
@interface TicketListViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) IBOutlet UITableView * __null_unspecified ticketTableView;
@property (nonatomic, copy) NSArray<PFObject *> * __nonnull tickets;
@property (nonatomic, copy) NSArray<PFObject *> * __nonnull users;
@property (nonatomic) NSTimer * __nonnull timer;
@property (nonatomic, copy) NSString * __nonnull currentUser;
@property (nonatomic, copy) NSString * __nonnull currentUserType;
@property (nonatomic) AssignView * __null_unspecified assignView;
@property (nonatomic, copy) NSString * __nonnull assignee;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)dismissAssignView:(NSIndexPath * __nullable)index;
- (IBAction)AddButtonPressed:(id __nonnull)sender;
- (void)didReceiveMemoryWarning;
- (void)refreshTickets:(NSArray<NSIndexPath *> * __nonnull)indexPaths;
- (void)refreshTicketList;
- (void)refreshUserList;
- (void)assignTicket:(NSIndexPath * __nonnull)index;
- (NSInteger)numberOfSectionsInTableView:(UITableView * __nonnull)tableView;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSString * __nonnull)checkCellType:(PFObject * __nonnull)ticket;
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextView;

SWIFT_CLASS("_TtC8MamaBear20TicketViewController")
@interface TicketViewController : UIViewController
@property (nonatomic) IBOutlet UITextView * __null_unspecified titleTextField;
@property (nonatomic) IBOutlet UITextView * __null_unspecified descTextField;
@property (nonatomic) IBOutlet UIButton * __null_unspecified assignButton;
@property (nonatomic, copy) NSString * __null_unspecified currentUserType;
@property (nonatomic, copy) NSArray<PFObject *> * __nonnull users;
@property (nonatomic, copy) NSString * __nonnull creator;
@property (nonatomic, copy) NSString * __nonnull assignee;
@property (nonatomic, copy) NSString * __nonnull assigned;
@property (nonatomic) AssignView * __null_unspecified assignView;
- (void)viewDidLoad;
- (IBAction)assignButtonPressed:(id __nonnull)sender;
- (void)dismissAssignView:(NSIndexPath * __nullable)index;
- (IBAction)submitButtonPressed:(id __nonnull)sender;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop