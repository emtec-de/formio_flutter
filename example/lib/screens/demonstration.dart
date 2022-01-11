import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';

class DemonstrationPage extends StatefulWidget {
  final String? argument;

  DemonstrationPage({this.argument});

  @override
  _DemonstrationPageState createState() => _DemonstrationPageState();
}

class _DemonstrationPageState extends State<DemonstrationPage>
    implements ClickListener {
  Future<List<Widget>>? _widgets;
  // ignore: unused_field
  BuildContext? _context;
  late WidgetProvider widgetProvider;

  @override
  Widget build(BuildContext context) {
    widgetProvider = WidgetProvider.of(context)!;
    _widgets ??= _buildWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('FormIO.Flutter'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          _context = context;
          return FutureBuilder<List<Widget>>(
            future: _widgets,
            builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return (snapshot.hasData)
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>
                              snapshot.data![index],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          );
        },
      ),
    );
  }

  Future<List<Widget>> _buildWidget(BuildContext context) async {
    late String _json;
    switch (widget.argument) {
      case "textfield":
        _json = await rootBundle.loadString('assets/textfield.json');
        break;
      case "multiTextfields":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "buttons":
        _json = await rootBundle.loadString('assets/buttons.json');
        break;
      case "datetime":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "select":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "checkbox":
        _json = await rootBundle.loadString('assets/checkbox.json');
        break;
      case "file":
        _json = await rootBundle.loadString('assets/file.json');
        break;
      case "signature":
        _json = await rootBundle.loadString('assets/signature.json');
        break;
      case "pagination":
        _json = await rootBundle.loadString('assets/multi.json');
        break;
      case "noPagination":
        _json = await rootBundle.loadString('assets/multi.json');
        break;
      case "validatorSignature":
        _json = await rootBundle.loadString('assets/signature_validator.json');
        break;
      case "validatorFields":
        _json = await rootBundle.loadString('assets/fields_validator.json');
        break;
      default:
    }
    var formCollection = FormCollection.fromJson(json.decode(_json));
    List<Map<String, dynamic>> defaultMapper = [
      {'textField': 'this is a demo'},
      {
        'signature2':
            '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n/J8TiICk5qaSmz5Kisr85yuxMXF4YMHD2jLaG1txQ8++IDnP37GjBmSYF0g7t27h1u3bhX40vKifv368b0vKL4KQOc0VEFBAdXU1HDAgAGor6+PRkZGaG5ujjY2Njh06FA0NTWlHUm4fQizycnJiWd9f/zxB+7fv18q/S0JXLhwgdiQ4VZHOnXqFN9nxWqifO3aNYiPj4dz584Raa2traChoUHKN3PmTEhISIBhw4bRllNTUwMffvghNDU10d5ftGgRpKWliY9xHrh37x4UFxfDvn37oLW1FcrKyuDx48fdKtPCwgIqKyt53q+trQUVFRUwNjYGExMTMDY2pvw2MjICZWVloep78eIFPH78mKATJ06AiooKXL58Ga5evUrk4479yIa/vz8sXrwYcnNzoampCebPny9ag3sZbty4AREREdDR0QEAAJcuXYL3338famtrISIiAlgsFv8CxCW1vBblbLKwsMDw8HAsKiriW05hYSFxgq6jo0M5TV+7dq24WCahpaUFc3JycOPGjThhwgQcOnQoUaew50PCEKdpsaamJrq7u2NUVBRu3rwZs7KyejQqV0tLC164cAFXrFhBa70J0Kmew3m9fv36HuNP3Kirq+P5vxw3bpxQZXRbYEpKSgQabA0bNkyojj5x4gRlHm1tbU3EVRG3L+IrV65gUlISenh4CBVZSxAJc6rv7e2NWVlZeOfOHbG2RRy4f/8+pqSk0GrsctKnn34qbVZFRkdHB44aNYq2PZ6envj69WuhyumWwPBbY7Bp0aJFQpn3btmyhWcZ7u7uIvsypkNbWxv+/PPPOHfuXDQ1NSXVIeglEURWVlbo4uIicEuX3w5Mb0JJSQlPbYp58+ZhYmKitFkUGq2trejv70/bHisrK57raDp0SWD+/vtvDAsLQwDqoolNtra2Qsc03Lx5M0/jLUNDw245pMjPz8fk5GR8//33+YZ34PX14Ufu7u546NAhfP78OVEfP6tNdr9ISsdNEpg9ezaJf05r0B9//FHa7AlEU1MTaQbEuaupra2NV69eFak8kQXmp59+Ih1AMhgMigpIfHy80OUdOnQIAYCiYgLQucUqqg39xYsXccOGDchisSjTLHY4Nl4vsrCCYmJigkePHqXUfebMGUpe9m6hi4sLsWUcHR0tUpukjSVLliAA1bRCT0+vxyMhi4JHjx7RftDZThy7YuItksDQ2YRwSq2Dg4NITJSVlZG2PjnPIEJDQ4U+YykoKMDFixejsbExbVwXNtEp2HES29M9P03k+fPn87Tn/+CDD3DMmDGkcxAzMzPaLeibN28K3U+9AbzWqWPGjJE2a7S4e/cuX1WlhISELpUrlMBUVVUJPIEeO3asyJXT2brr6+vjxIkTBT57/PhxXLVqFeWrx09thG59MXbsWJw4cSJJ8Y57Zwig06OMoD16TkEZPnw4MplMXLduHa3f4//85z8i95e0wctOqbdtAly5coWvNjunybGoECgw27ZtI8UY4abBgwd3aS57/Phx9PLywpiYGNIo8+GHH/J8pqamBlNTU5HJZKKCggKtvzHuXTa66VRUVBQePXoUs7KyeHqY4RQ8bqs7OhQVFdGW09zcjBs2bKC9d/v2bZH7TZp4/Pgx5eBTW1sbk5OTMS8vT9rsIWLntJgunDgAoKKiImZlZXWrfL4Ck5WVhUOGDMGZM2fSMhASEoK1tbVdqnjChAlEOfLy8qijo4NmZmaU6c6NGzcwIyODdnjl5S6VU7NAV1cXw8PDMT09HUtKShCxc9OCezFLN9K5urri77//LlR7uM1bAQCDgoIQsfO8g86bIqe/q76C7Oxsgn9bW1tCkXPmzJnSZg3XrVtH8MY9DdbU1MTffvut23XwFJjCwkJCoVBFRYXywq5bt65bFWdnZ2NCQgLpwMzf3x+DgoJwwYIF6ObmRjq0pFsH8FJPsbKywq+++ooQEE6EhYXxNC9gk5qamsgmwnQHf5zav6tXrybd8/T0RB8fH6yvr+9WP0oDkyZNop11SMtcoK6ujvaIg71m1dfXx/z8fLHURSswlZWVpJNuNqmoqKCFhYVYHMipqqqiqqoqqqiokHbZ6OK0APDWsWKvDwICAnDXrl2ED1xubNu2Dc3NzflOLwEAY2JiRA6AevfuXdqyOMNLNDQ0oLq6Orq5uZF267r74ZEW2PE+OUlSWhj8cOrUKdp3lT3TYLFYtB/OroIiME+fPuW5u2BnZ8dTq1hU1NfXY3p6OkZGRpIEhnMbkNtVKrenlffeew9DQ0Mpdtec2L17N2UBSDeV8/Dw6HIY8O3bt1PK4wzCwwbd1NbY2LhLdUobdDumpqamPcpDUlIS349fYGCg2NeJFIHJzc2lHd6cnZ3FavJ68OBBLCoqwvj4eAwMDCRO3jl3vbh3ZRgMBqqrqyODwUBNTU308/OjeJBkY//+/bS7XQCdnvrZi9cBAwZ023Bq/PjxlDpWrFhByVdVVUXLz969e7tVvzRw+/Zt2rZ8//33Eq87Ly8PfXx8eI4sAICff/65ROomCcyff/5JfIE5T75NTU0lEr2qo6MDdXR0MC4uDsPCwlBPT490BvLxxx8Tc9G5c+eihYUFWltbo6amJlpZWRHbuHZ2drh9+3ZERNy3b59Qai4hISE4d+5cfPLkSbfa8Pr1a8KnMyfxmjN/+OGHlLyenp7d4kFaiIyMpLTF399fYvU1NDRgXFwcURddHBd9fX2J+nIjCQy3X1lNTU1UVlbG4uJiiTFQWlqK69evx1WrVuHkyZPx448/xo0bN+K+ffswKysLGxsbsampCefMmYPh4eHo5ORETNu41VkUFRVpO5GbIiIixGaleebMGfTy8sIxY8YQI5qhoSHP/Dk5ObQ8cZtk9wWcPXuW4F9PTw9DQ0NxwoQJEtku37FjB6GEy0mc/g2CgoL4Ts/FAUJgXrx4QWtwNGfOHIkyICzOnDmDQUFBRMcoKSkJHfeFTWFhYWLbLWGDLtirt7c332e4z36GDRuGrq6uYuWrpzB06FCKCcbOnTvFVn5+fr5Abfjx48fjypUrxVYnPxACc/fuXVyxYgVp90NVVRWbm5t7hBFhsWnTJrS3t+drhstNDAYD9+zZIxF+6DQgBL0w+/btI6ZinJaOV65ckQiPksSKFSso7RdGU0MQqqqqaD3pc5Obmxv+8ssvYmiJcCAEJjExEW1sbNDGxgYNDAxQVVUV3d3de4wRYZCTk4MBAQG0awZhyNXVFZOTk7GyslJsPNGd6Vy7dk3gc3S2+9OmTRMbXz2F3NxcSju0tLS6XF5BQQHGxMQQU1te/0tVVVVMTU0VY0uEAyEw3Adr7PmhtFFaWorLly8nbTELiv/CyysKJzk4OOD69eu79VW/fPkypVxdXV2hns3IyKDlqy966afTYsjJyRGpjP3791PWpLy838yaNUskGxZxghCY9PR0TE9Px6lTpxIvpJmZmVSYunjxIqakpPA0m+X0q8VJ1tbWqKqqipMmTRIoMJxTIVNTU5wzZw6ePHkSX716JTSfX331FaXc8ePHC/083QZFX1P9R0RKf1taWgpl4vHgwQNcvXo13+1hzvWLi4sLnj59ugdaxBuEwJw+fZrEOPsUXpze7/mhpKQEk5KSCCHhF99RTU2NpAQYGxtLxHlsbm7GtLQ0vgtFBQUFnsZk/fr1w6CgIMzIyBBoAEfnQmrDhg1CtzklJYWWh76m+h8bG4sWFhbo6OiIdnZ2qKuryzMkYUNDAx46dIingiQ3hYSEoLKyMsnBuzRB2lZ2cnJCOzs7kvdFBoOB3333ndgrbm9vxy+//BIXL15MO/QKilM5ZcoUXLJkCV8Dpjt37mBqaiplRBIU4x7gX99eFhYWOHv2bDx06BA+evSIVD6dyyJRpiJtbW20qv8TJkzocr9KAxcvXqS0gdPV6vXr13Hz5s2ksIfC+D/Q1dXFhIQELCwslGLryCAJzIkTJ0iWj+zzDnV1daHjOfLCmzdvMCcnB9esWYP+/v6oqKiI9vb2PDuL2+aeTePGjcO9e/diQ0ODSPXfvHkTN2zYgM7OzkIFXeUlVC4uLvjpp5/iDz/8gJGRkRgWFoY+Pj5oaWmJcnJy2NraKhJf69evJ/U3e4TlFs7ejEePHlH6SVVVFRctWsTXLoWXBay7uzt+8803tF5QpQ2Kagzb0yTnS8Ve1A0bNgwXL14sMMx1R0cHlpWV4YEDBzAuLg69vLxoY78IUoRkn9h7eHhgenp6l00JuHH9+nVMS0vjKzi81k/8yMjISGReGhsb0dnZmTJF6ampsLggjKtcbgoODiZdT5kypdcf4NJqK3PqknFOZzi3+TQ0NJDBYKCnpyeOGTMGw8LC0NTUFB0cHCg2/rxGCwB660aATt218ePHS9zHb3NzMx47dgxjY2OJNZyysnKX3S4NGjQIAwMDcdmyZXj06FGhfBIkJCRQyhkyZIhE290d/P3333jy5ElMSEjAUaNG8Y0+zY9cXFzQ0NAQV65ciffu3ZN2s4QCrcDU1dWhnZ0dzp8/n2TWyznfpot9wuswkd96hH16D9Cph5SWliay4wtxoqioCKOiotDHx6dLLwEdDRw4EP39/dHX1xd37dqFubm5JH/FvBQZd+/eLbV+YKOxsRGPHj2K27ZtwxkzZgjlWF4QWVpa4oIFCzArK6tXTrv4QQ4REWhQWVkJBQUFEBUVBQAAwcHBkJWVRdy3tbWF8vJy0jOOjo4k96Ns+Pn5QU5ODiXd0NAQ7O3tITIyEsaNGwe6urp0rEgNzc3NcP78eYKuXbvWrfKsra2hoqKCuNbT0wNra2uwtraGq1evQklJCSm/u7s7FBYWdqtOQaipqYH79+8TxH3d0NAAw4cPhxs3bghVnpycHMjJyRGuWNnw9fUFFosFLBYL7O3tJdGUHgFP38pWVlZgZWUFCgoKsHnzZmAymSSBsbKyogiMvr4+bVlsH8lDhgwBb29v8PHxAW9vbxgxYoQ42iAxaGhoQEhICISEhABA58vFFp6ff/4ZGhsbRSrv4cOHpOv6+nqor6+Hixcv0uYvKiqCoUOHgo6ODqioqICqqipBnNfXrl0DZ2dnaGtrgzdv3hB/OX9zplVXV0N7ezvU1NRAe3u7QL6VlJSEbiN2zloAAGDkyJEQHx8PLBYLdHR0hC6jV0PYoej06dO4evVqDAwMRG1tbfzkk08oQy1nxOAhQ4bg2LFjccmSJfjdd9+9dfFG6JQu+XnmNzMzE9sUj5uECZHBSaJESgMAvjtdbKJb80nDAlPSENp7f2BgIAQGBhLXOTk5MG3aNHj58iW0tLQQf6dNmwYjRozgOdq8LaiurgYXFxdQVFQEOTk5AAAYPHgwJCYmwtWrVwkqKSmB5uZmMDY2hjt37ghVtpaWFs/IBXQQ1pM/G5qamiLlr6+vB21tbWhoaCDSHB0dwd3dHZhMJjCZTDhy5AgkJiaSnmtraxOpnr6ALoe78PPzEycffQ6Kiopw5coVUtqePXvA3t4e7O3tYebMmUT6X3/9BV9//TX4+PhARUUFVFRUwM2bN6G1tZW2bFGEBUB0gVFXVxc6r5KSEmhra4OFhQV4enoSAsItdOyPBidkAiMDgRcvXlDSeH25bWxsYOvWrZT0qqoqkgBVVFRAaWkpPH/+XCReRBUYNTU14reuri4Rd4aODAwMhCrzzp07oKmpCTo6OjBw4EDQ1dWFp0+fisRXX4BMYLoIOoHhDhwlCJaWlmBpaQnBwcGkdFdXV8roZW5uDpmZmfDq1St4/fo1vHr1iqCLFy9CamoqKCoqgoKCAvGX1+/Hjx/DunXrwNjYWKTRhh9UVVXhxYsX8OLFC7h79y4AAKSnp4ul7N4EmcB0EaKMMKJi9erVMG7cOFLa7du3ISsrC1JSUij5FyxYIJZ6uwO6yGxv4zpWXtoM9FU0NzdT0lRUVMRSdnBwMEVg3NzcYM+ePVBfXy+WOsQN7i1zAIBBgwZJgRPJQiYwXcTSpUth4cKF4OvrS3xJ+cWuFBXLli0DgM4Yk2ZmZlBcXAwNDQ2QkJAgtjrEibKyMjA2NgYHBwewt7eHwYMHv5UjjMTCjr/toLOFEXf8R04zC07qSRt2YXD8+HESf4MGDcKPP/5YbE4fexNkI0wX4eHhQUm7dOmSWOvYvXs3aGtrU9J72yjz/fffk67r6urgyZMn0L9/fylxJDnIBKaLoBOYgoICsdahr68PycnJlPTy8nIYM2aMWOvq2rP1MwAABApJREFUKh49egTHjh2jpE+ePFkK3PQApD3E9WVw+kUzMDBAPz8//OGHH8ReDzvEHJvY/gh6Q6zMzz77DJlMJklTfejQodJmS2Lgqa0sg2A4OTkBQKfqyIMHDwAA4MCBAzB16lSx1lNWVgYjR44Eb29vePbsGaH0qq2tDcXFxWBpaSnW+kSBnZ0dXL9+HQA6d/I0NDTA2dkZNm3aJDWeJAppS2xfBjtYKicJE62sK4iJiaGNrubr6yuR+oTBqVOnaDcl/vjjD6nxJGnI1jDdgJ2dHSXt119/JX6zv7ziQGZmJkUjAAAgNzcXwsPDxVaPKNizZw8ljcViESPv2wiZwHQDnAKjoKAAAwYMgPLychg3bhwwGAyws7ODkSNHwrNnz8RSX2ZmJu3067fffoO5c+eKpQ5hcerUKSgtLaWkR0dH9ygfPQ5pD3F9GW1tbXjw4EFMSkpCLS0tnrYiaWlpYqvzwoULRLmampokzysBAQE9FjYvPDwcATrdwo4ePRr19fXR3Ny8R+qWJmQC003Ex8cLNK46cOCAWOvcsmULenp6kgLrssnc3By/+eYbsdbHjSNHjlDqdXR07JNBbkWFTGDEAAcHBzQwMMCgoCDaEByScITIK5Q5QKezEnFrHbBRVVVF61KJwWBIpL7eBpnAiAE5OTkYHR2NQ4YMwYCAAAwNDSX8U8+ePVti9W7bto3y4jKZTOL3qFGjxLpjlZ+fT7ii4vb6uX//frHV05shExgx4ciRI7h+/Xpcvnw53rt3D1+9eoVRUVESrzc7O5uI6cMZjYuTgoODRfYUyomqqiqcOHEixbVWUFAQTps2DQMCAsTYot4NmcCIEZWVlXjixIker7eqqgr9/PxofT2zqV+/fhgbGytSBLbdu3djSEgIUYacnByl3Li4OMzLy5Ng63oXZCf9bxGWLVsGX3zxBSnNzc0NiouLSWlaWloQHh4ODAYDGAwG/PPPP8BgMAAA4NatW1BYWAgnTpyAhw8fUp4PCAiAc+fOAQCAiYkJHD58GJhMpoRb1osgbYmVQbw4f/484UbJxMSE1lMldwAkzjCN3MTp+RQAcMSIEfjRRx+hm5ubRIK/9nbIRpi3FAkJCSAvL0/RdlZVVYVXr16R0oyMjAhdODpwe+w8ffo0+Pj4kJxpvCuQnfS/pfjiiy9gypQpsHjxYhg4cCCRPn78eEpebs+WNjY2pGsTExOwtLSE9evXQ21tLQQGBr6TwgIgE5i3GiNGjIDU1FSor6+HzMxM8PLyAkdHR1IeFRUVUFRUJKVNnDiR+D158mSIioqCW7duwfLly4V2u/S2QjYle8dQVVUFt27dIhG3rts333wDubm5MGXKlF7nIF7akAmMDDKIANmUTAYZRMD/ANBXVIt1FH1mAAAAAElFTkSuQmCC'
      }
    ];
    formCollection = await parseFormCollectionDefaultValueListMap(
      formCollection,
      defaultMapper,
    );
    return WidgetParserBuilder.buildWidgets(
      formCollection,
      context,
      this,
      widgetProvider,
    );
  }

  @override
  void onClicked(String event) async {
    switch (widget.argument) {
      case "validatorSignature":
        break;
      case "validatorFields":
        break;
      default:
    }
  }
}
