import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../data/profile_repository.dart';

class CurrencyData {
  const CurrencyData(
    this.symbol,
    this.countryCode,
    this.name,
  );

  final String symbol;
  final String countryCode;
  final String name;
}

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key});

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  final searchController = TextEditingController();

  List<CurrencyData> allCurrencies = [
    const CurrencyData('\$', 'USD', 'US Dollar'),
    const CurrencyData('€', 'EUR', 'Euro'),
    const CurrencyData('£', 'GBP', 'British Pound'),
    const CurrencyData('¥', 'JPY', 'Japanese Yen'),
    const CurrencyData('₹', 'INR', 'Indian Rupee'),
    const CurrencyData('₽', 'RUB', 'Russian Ruble'),
    const CurrencyData('₩', 'KRW', 'South Korean Won'),
    const CurrencyData('₪', 'ILS', 'Israeli Shekel'),
    const CurrencyData('₨', 'PKR', 'Pakistani Rupee'),
    const CurrencyData('₡', 'CRC', 'Costa Rican Colón'),
    const CurrencyData('₦', 'NGN', 'Nigerian Naira'),
    const CurrencyData('₱', 'PHP', 'Philippine Peso'),
    const CurrencyData('₫', 'VND', 'Vietnamese Dong'),
    const CurrencyData('₵', 'GHS', 'Ghanaian Cedi'),
    const CurrencyData('₲', 'PYG', 'Paraguayan Guaraní'),
    const CurrencyData('₴', 'UAH', 'Ukrainian Hryvnia'),
    const CurrencyData('₸', 'KZT', 'Kazakhstani Tenge'),
    const CurrencyData('₼', 'AZN', 'Azerbaijani Manat'),
    const CurrencyData('R', 'ZAR', 'South African Rand'),
    const CurrencyData('R\$', 'BRL', 'Brazilian Real'),
    const CurrencyData('kr', 'SEK', 'Swedish Krona'),
    const CurrencyData('Kč', 'CZK', 'Czech Koruna'),
    const CurrencyData('zł', 'PLN', 'Polish Zloty'),
    const CurrencyData('Ft', 'HUF', 'Hungarian Forint'),
    const CurrencyData('lei', 'RON', 'Romanian Leu'),
    const CurrencyData('лв', 'BGN', 'Bulgarian Lev'),
    const CurrencyData('din', 'RSD', 'Serbian Dinar'),
    const CurrencyData('kn', 'HRK', 'Croatian Kuna'),
    const CurrencyData('Lt', 'LTL', 'Lithuanian Litas'),
    const CurrencyData('Ls', 'LVL', 'Latvian Lats'),
    const CurrencyData('₺', 'TRY', 'Turkish Lira'),
    const CurrencyData('S\$', 'SGD', 'Singapore Dollar'),
    const CurrencyData('HK\$', 'HKD', 'Hong Kong Dollar'),
    const CurrencyData('CA\$', 'CAD', 'Canadian Dollar'),
    const CurrencyData('AU\$', 'AUD', 'Australian Dollar'),
    const CurrencyData('NZ\$', 'NZD', 'New Zealand Dollar'),
    const CurrencyData('CHF', 'CHF', 'Swiss Franc'),
    const CurrencyData('M\$', 'MXN', 'Mexican Peso'),
    const CurrencyData('﷼', 'SAR', 'Saudi Riyal'),
    const CurrencyData('\$', 'ARS', 'Argentine Peso'),
    const CurrencyData('BYN', 'BYN', 'Belarusian Ruble'),
    const CurrencyData('AMD', 'AMD', 'Armenian Dram'),
    const CurrencyData('\$', 'AWG', 'Aruban Florin'),
    const CurrencyData('\$', 'BSD', 'Bahamian Dollar'),
    const CurrencyData('\$', 'BBD', 'Barbadian Dollar'),
    const CurrencyData('\$', 'BZD', 'Belize Dollar'),
    const CurrencyData('\$', 'BMD', 'Bermudian Dollar'),
    const CurrencyData('Nu.', 'BTN', 'Bhutanese Ngultrum'),
    const CurrencyData('B\$', 'BOB', 'Bolivian Boliviano'),
    const CurrencyData('KM', 'BAM', 'Bosnia-Herzegovina Convertible Mark'),
    const CurrencyData('P', 'BWP', 'Botswanan Pula'),
    const CurrencyData('\$', 'BND', 'Brunei Dollar'),
    const CurrencyData('៛', 'KHR', 'Cambodian Riel'),
    const CurrencyData('¥', 'CNY', 'Chinese Yuan'),
    const CurrencyData('\$', 'COP', 'Colombian Peso'),
    const CurrencyData('CF', 'KMF', 'Comorian Franc'),
    const CurrencyData('FC', 'CDF', 'Congolese Franc'),
    const CurrencyData('kr', 'DKK', 'Danish Krone'),
    const CurrencyData('Nfk', 'ERN', 'Eritrean Nakfa'),
    const CurrencyData('kr', 'EEK', 'Estonian Kroon'),
    const CurrencyData('Br', 'ETB', 'Ethiopian Birr'),
    const CurrencyData('\$', 'FJD', 'Fijian Dollar'),
    const CurrencyData('D', 'GMD', 'Gambian Dalasi'),
    const CurrencyData('₾', 'GEL', 'Georgian Lari'),
    const CurrencyData('Q', 'GTQ', 'Guatemalan Quetzal'),
    const CurrencyData('GNF', 'GNF', 'Guinean Franc'),
    const CurrencyData('\$', 'GYD', 'Guyanaese Dollar'),
    const CurrencyData('G', 'HTG', 'Haitian Gourde'),
    const CurrencyData('L', 'HNL', 'Honduran Lempira'),
    const CurrencyData('kr', 'ISK', 'Icelandic Króna'),
    const CurrencyData('Rp', 'IDR', 'Indonesian Rupiah'),
    const CurrencyData('﷼', 'IRR', 'Iranian Rial'),
    const CurrencyData('﷼', 'IQD', 'Iraqi Dinar'),
    const CurrencyData('\$', 'JMD', 'Jamaican Dollar'),
    const CurrencyData('﷼', 'JOD', 'Jordanian Dinar'),
    const CurrencyData('₩', 'KPW', 'North Korean Won'),
    const CurrencyData('﷼', 'KWD', 'Kuwaiti Dinar'),
    const CurrencyData('с', 'KGS', 'Kyrgystani Som'),
    const CurrencyData('₭', 'LAK', 'Laotian Kip'),
    const CurrencyData('﷼', 'LBP', 'Lebanese Pound'),
    const CurrencyData('M', 'LSL', 'Lesotho Loti'),
    const CurrencyData('\$', 'LRD', 'Liberian Dollar'),
    const CurrencyData('﷼', 'LYD', 'Libyan Dinar'),
    const CurrencyData('ден', 'MKD', 'Macedonian Denar'),
    const CurrencyData('Ar', 'MGA', 'Malagasy Ariary'),
    const CurrencyData('MK', 'MWK', 'Malawian Kwacha'),
    const CurrencyData('RM', 'MYR', 'Malaysian Ringgit'),
    const CurrencyData('₨', 'MVR', 'Maldivian Rufiyaa'),
    const CurrencyData('CFA', 'XOF', 'West African CFA Franc'),
    const CurrencyData('₨', 'MUR', 'Mauritian Rupee'),
    const CurrencyData('₮', 'MNT', 'Mongolian Tugrik'),
    const CurrencyData('﷼', 'MAD', 'Moroccan Dirham'),
    const CurrencyData('MT', 'MZN', 'Mozambican Metical'),
    const CurrencyData('K', 'MMK', 'Myanmar Kyat'),
    const CurrencyData('N\$', 'NAD', 'Namibian Dollar'),
    const CurrencyData('₨', 'NPR', 'Nepalese Rupee'),
    const CurrencyData('C\$', 'NIO', 'Nicaraguan Córdoba'),
    const CurrencyData('kr', 'NOK', 'Norwegian Krone'),
    const CurrencyData('﷼', 'OMR', 'Omani Rial'),
    const CurrencyData('B/.', 'PAB', 'Panamanian Balboa'),
    const CurrencyData('K', 'PGK', 'Papua New Guinean Kina'),
    const CurrencyData('S/.', 'PEN', 'Peruvian Nuevo Sol'),
    const CurrencyData('﷼', 'QAR', 'Qatari Rial'),
    const CurrencyData('₨', 'SCR', 'Seychellois Rupee'),
    const CurrencyData('Le', 'SLL', 'Sierra Leonean Leone'),
    const CurrencyData('SI\$', 'SBD', 'Solomon Islands Dollar'),
    const CurrencyData('S', 'SOS', 'Somali Shilling'),
    const CurrencyData('Rs', 'LKR', 'Sri Lankan Rupee'),
    const CurrencyData('£', 'SDP', 'Sudanese Pound'),
    const CurrencyData('Sr\$', 'SRD', 'Surinamese Dollar'),
    const CurrencyData('E', 'SZL', 'Swazi Lilangeni'),
    const CurrencyData('kr', 'SEK', 'Swedish Krona'),
    const CurrencyData('CHF', 'CHF', 'Swiss Franc'),
    const CurrencyData('£', 'SYP', 'Syrian Pound'),
    const CurrencyData('TJS', 'TJS', 'Tajikistani Somoni'),
    const CurrencyData('TSh', 'TZS', 'Tanzanian Shilling'),
    const CurrencyData('฿', 'THB', 'Thai Baht'),
    const CurrencyData('T\$', 'TOP', 'Tongan Paʻanga'),
    const CurrencyData('TT\$', 'TTD', 'Trinidad and Tobago Dollar'),
    const CurrencyData('DT', 'TND', 'Tunisian Dinar'),
    const CurrencyData('₼', 'TMT', 'Turkmenistani Manat'),
    const CurrencyData('USh', 'UGX', 'Ugandan Shilling'),
    const CurrencyData('﷼', 'AED', 'UAE Dirham'),
    const CurrencyData('\$U', 'UYU', 'Uruguayan Peso'),
    const CurrencyData('UZS', 'UZS', 'Uzbekistan Som'),
    const CurrencyData('VT', 'VUV', 'Vanuatu Vatu'),
    const CurrencyData('Bs', 'VEF', 'Venezuelan Bolívar'),
    const CurrencyData('₫', 'VND', 'Vietnamese Dong'),
    const CurrencyData('EC\$', 'XCD', 'East Caribbean Dollar'),
    const CurrencyData('CFA', 'XAF', 'Central African CFA Franc'),
    const CurrencyData('﷼', 'YER', 'Yemeni Rial'),
    const CurrencyData('ZK', 'ZMW', 'Zambian Kwacha'),
    const CurrencyData('Z\$', 'ZWL', 'Zimbabwean Dollar'),
  ];

  void onCurrency(CurrencyData value) async {
    await context.read<ProfileRepository>().setCurrency(value.symbol);
    setState(() {});
    if (mounted) {
      context.read<InvoiceBloc>().add(GetInvoices());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();

    final currencies = query.isEmpty
        ? allCurrencies
        : allCurrencies.where((element) {
            final name = element.name.toLowerCase();
            final country = element.countryCode.toLowerCase();

            return name.contains(query) || country.contains(query);
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Field(
            controller: searchController,
            onChanged: (_) {
              setState(() {});
            },
            hintText: 'Search currency',
            asset: Assets.search,
          ),
        ),
        const SizedBox(height: 8),
        const TitleText(
          title: 'List of currencies',
          left: 16,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currencyData = currencies[index];

              return _CurrencyTile(
                currencyData: currencyData,
                onPressed: onCurrency,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currencyData,
    required this.onPressed,
  });

  final CurrencyData currencyData;
  final void Function(CurrencyData) onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    final currency = context.read<ProfileRepository>().getCurrency();

    return Button(
      onPressed: () {
        onPressed(currencyData);
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: colors.tertiary3,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      currencyData.symbol,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontFamily: AppFonts.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currencyData.name,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontFamily: AppFonts.w500,
                      ),
                    ),
                  ),
                  Text(
                    currencyData.countryCode,
                    style: TextStyle(
                      color: colors.text2,
                      fontSize: 14,
                      fontFamily: AppFonts.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (currencyData.symbol == currency)
              SvgWidget(
                Assets.checked,
                color: colors.accent,
              ),
          ],
        ),
      ),
    );
  }
}
