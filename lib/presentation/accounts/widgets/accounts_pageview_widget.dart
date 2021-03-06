import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../app/routes.dart';
import '../../../common/enum/box_types.dart';
import '../../../common/enum/card_type.dart';
import '../../../common/widgets/empty_widget.dart';
import '../../../data/accounts/model/account.dart';
import '../bloc/accounts_bloc.dart';
import 'account_card.dart';

class AccountPageViewWidget extends StatelessWidget {
  AccountPageViewWidget({Key? key}) : super(key: key);
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Account>>(
      valueListenable:
          Hive.box<Account>(BoxType.accounts.stringValue).listenable(),
      builder: (context, value, _) {
        final accounts = value.values.toList();
        if (accounts.isEmpty) {
          return EmptyWidget(
            icon: Icons.credit_card,
            title: AppLocalizations.of(context)!.errorNoCardsLable,
            description:
                AppLocalizations.of(context)!.errorNoCardsDescriptionLable,
          );
        }
        BlocProvider.of<AccountsBloc>(context)
            .add(AccountSeletedEvent(accounts[0]));
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: PageView.builder(
                key: const Key('accounts_page_view'),
                controller: _controller,
                padEnds: true,
                itemCount: accounts.length,
                onPageChanged: (index) => BlocProvider.of<AccountsBloc>(context)
                    .add(AccountSeletedEvent(accounts[index])),
                itemBuilder: (_, index) {
                  final account = accounts[index];
                  return AccountCard(
                    key: ValueKey(account.hashCode),
                    cardHolder: account.name,
                    cardNumber: account.number,
                    bankName: account.bankName,
                    cardType: account.cardType ?? CardType.debitcard,
                    onDelete: () => BlocProvider.of<AccountsBloc>(context)
                        .add(DeleteAccountEvent(account)),
                    onTap: () =>
                        context.goNamed(addAccountPath, extra: account),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
