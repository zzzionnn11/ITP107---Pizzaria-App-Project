class Account {
  final String email;
  final String password;

  const Account(this.email, this.password);
}

class AccountStore {
  AccountStore._();

  static final List<Account> _accounts = [
    const Account('johnkennethperjes@gmail.com', 'kennethpog123'),
  ];

  static bool emailExists(String email) {
    return _accounts.any(
      (account) => account.email.toLowerCase() == email.toLowerCase(),
    );
  }

  static void register(String email, String password) {
    _accounts.add(Account(email, password));
  }

  static bool authenticate(String email, String password) {
    return _accounts.any(
      (account) =>
          account.email.toLowerCase() == email.toLowerCase() &&
          account.password == password,
    );
  }
}
