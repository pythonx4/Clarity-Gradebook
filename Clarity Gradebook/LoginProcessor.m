//
//  LoginProcessor.m
//  Clarity Gradebook
//
//  Created by tj on 12/23/12.
//  Copyright (c) 2012 Fire30. All rights reserved.
//

#import "LoginProcessor.h"

#define UA @"User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11"
#define VIEWSTATE @"/wEPDwUJOTE3NjQwMjU1D2QWAgIDD2QWBAIDDw8WBB4EVGV4dAWxBQ0KDQo8cCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXI7IG1hcmdpbi1ib3R0b206IDNweDsiPjxiPldlbGNvbWUgdG8gdGhlIFBpbm5hY2xlIEludGVybmV0IFZpZXdlci48L2I+PC9wPg0KPHA+VGhpcyBhcHBsaWNhdGlvbiBhbGxvd3MgeW91IHRvIHZpZXcgeW91ciBzdHVkZW50J3MgZ3JhZGVzIGFuZCBhdHRlbmRhbmNlIGluIGEgcmVhbC10aW1lIGF0bW9zcGhlcmUuIEJ5IHVzaW5nIHlvdXIgc3R1ZGVudCdzIGlkIG51bWJlciBhbmQgdGhlIHBhc3N3b3JkIGFzc2lnbmVkIGJ5IHlvdXIgc2Nob29sIGRpc3RyaWN0LCB5b3Ugd2lsbCBiZSBhYmxlIHRvIHZpZXcgeW91ciBzdHVkZW50J3MgY3VycmVudCBpbmZvcm1hdGlvbiBhcyB3ZWxsIGFzIGluZm9ybWF0aW9uIGZyb20gcHJldmlvdXMgbWFya2luZyBwZXJpb2RzLjwvcD4NCjxiciAvPg0KPHA+UGxlYXNlIHJlZmVyIHRvIExDUFMgcG9saWN5IDgtNzMgcmVnYXJkaW5nIGFjY2VwdGFibGUgdXNlIGZvciBwYXJlbnRzL2d1YXJkaWFucyBhY2Nlc3Npbmcgc3R1ZGVudCBpbmZvcm1hdGlvbiBvbiB0aGUgd2ViIGF0ICA8YSBocmVmPSJodHRwOi8vd3d3LkxDUFMub3JnIj53d3cuTENQUy5vcmc8L2E+PC9wPg0KPGJyIC8+DQo8cD5Qb2xpY3kgbGluazogPGEgaHJlZj0iaHR0cDovL2JpdC5seS9lbHB4STQiPmh0dHA6Ly9iaXQubHkvZWxweEk0PC9hPjwvcD4NCg0KHgdWaXNpYmxlZ2RkAgUPZBYCAgkPZBYCAgEPZBYCZg8QD2QWAh4FdGl0bGUFDkJyb2FkIFJ1biBIaWdoDxZdZgIBAgICAwIEAgUCBgIHAggCCQIKAgsCDAINAg4CDwIQAhECEgITAhQCFQIWAhcCGAIZAhoCGwIcAh0CHgIfAiACIQIiAiMCJAIlAiYCJwIoAikCKgIrAiwCLQIuAi8CMAIxAjICMwI0AjUCNgI3AjgCOQI6AjsCPAI9Aj4CPwJAAkECQgJDAkQCRQJGAkcCSAJJAkoCSwJMAk0CTgJPAlACUQJSAlMCVAJVAlYCVwJYAlkCWgJbAlwWXRAFEkFjYWRlbXkgb2YgU2NpZW5jZQUkNjkzZDZmNzMtYzE0MC00YWMzLTg1ZDEtNjhjMzNkZTc5NWZmZxAFEEFsZGllIEVsZW1lbnRhcnkFJDJkYThhNzhjLWFhYTktNGNlMC04MWIxLTU4MTdmN2FmNTdiNGcQBRRBbGdvbmtpYW4gRWxlbWVudGFyeQUkODc3ZjZiYjItOTNhNy00Zjg3LWE1YzUtMDRhMzQxYzZkMzQ2ZxAFEUFyY29sYSBFbGVtZW50YXJ5BSQ0OTgyNjgwNS05ZWE1LTQ5MmUtODU5Ni1iMjZlOGIxMjE1ZGJnEAUSQXNoYnVybiBFbGVtZW50YXJ5BSQ1MTZiNTA2ZS00ZmIwLTQ2OGUtYTAwNi0xMTFiZjExYjlmYjlnEAUXQmFsbCdzIEJsdWZmIEVsZW1lbnRhcnkFJDZjM2JhNTRlLTdhNDItNDkyNy05NzFjLTViMzU2NzZjYmJlYmcQBRNCYW5uZWtlciBFbGVtZW50YXJ5BSQ1OGYyNzZjNC1kNGQ4LTQ3NjYtOGNmNC1kNWE4ZDkzMDFmN2JnEAUUQmVsbW9udCBSaWRnZSBNaWRkbGUFJDcyYzU4MTJjLTRkMTktNGRiNy1hMTE2LTZhM2JiOTY0MTljMWcQBRpCZWxtb250IFN0YXRpb24gRWxlbWVudGFyeQUkZWFhZTU1NzUtYmM4Yi00ZjMwLTg2NjktYTYxMWJhZmY3YmRiZxAFGEJsdWUgUmlkZ2UgTWlkZGxlIFNjaG9vbAUkOWYyM2QwODYtNmRjMi00MDBhLWIxMGYtYzhlNDM0ODA1OWE4ZxAFEEJyaWFyIFdvb2RzIEhpZ2gFJGRhOWE1OGQ2LTYyNmEtNDYwOC05NTg3LWY2Y2Y3OTU0YjUwYWcQBQ5Ccm9hZCBSdW4gSGlnaAUkNGNiZmJkMWYtMzA3MC00ZDNmLWE0NDAtYTMzYTk4ZGU0NmE4ZxAFGEJ1ZmZhbG8gVHJhaWwgRWxlbWVudGFyeQUkMTQwMGY0ZDUtNjRhNy00Y2JiLTg4OTAtYzIyZWYzZjY0YzlmZxAFE0NhdG9jdGluIEVsZW1lbnRhcnkFJDE2ZGFiNDViLTYzNWQtNGRkNC1hYjVmLTljZTZjNWE2OTcwNWcQBRVDZWRhciBMYW5lIEVsZW1lbnRhcnkFJDBkMWY3OGQxLWUxYTYtNGFmZS1hMjJjLTgwN2U3OGQwMmQ2YWcQBRZDb29sIFNwcmluZyBFbGVtZW50YXJ5BSRkOWIwNDdiMS0yMWMwLTQwY2MtYjlkNC1lYWQ2YmQ2MTEzYWZnEAUWQ291bnRyeXNpZGUgRWxlbWVudGFyeQUkMWIwNGQzNDYtZGU2My00NDBjLTgxZmMtZmIxZWRhMDY0NDY0ZxAFHUNyZWlnaHRvbidzIENvcm5lciBFbGVtZW50YXJ5BSQzZmVkMDg3Zi0yYjk3LTRlODItODA4Yy00NzExNDlkMGRlMDJnEAUNRG9taW5pb24gSGlnaAUkMTViZWM4YjctYzU2Yy00YjEyLWE1MzktOGMxZGRiNTk3NzJlZxAFGURvbWluaW9uIFRyYWlsIEVsZW1lbnRhcnkFJDFkN2RiYTc2LTdiZTctNDY1My04MmEzLTAyZDMzNTIxZDQzNGcQBQ9Eb3VnbGFzcyBTY2hvb2wFJDc4MjAyMWZiLWQ4MTItNDE3My04NTYyLTQ1ODFhM2E1MDMwOWcQBRJFYWdsZSBSaWRnZSBNaWRkbGUFJGQ5MGVlODQ5LTdjMmYtNGE0MC04MmIyLWVhYzllNTUyODhkY2cQBRJFbWVyaWNrIEVsZW1lbnRhcnkFJDQxY2E2MDQ2LTUxMzktNDdlZS04ZDI3LWU5NGM3MmY5ZGY4OWcQBRlFdmVyZ3JlZW4gTWlsbCBFbGVtZW50YXJ5BSQ0YTk4MDhlNy05ZDIwLTQ4ZGItOWVjZi03YmY0NWQyOTI0MDBnEAUXRmFybXdlbGwgU3RhdGlvbiBNaWRkbGUFJDkwODEyM2M3LTJmYjQtNDU1Ny1hMmFlLWExNmVlYzU3MGQxMmcQBRdGb3Jlc3QgR3JvdmUgRWxlbWVudGFyeQUkZjE4NTYwNmMtNTgxMi00NDRjLWIzZjEtM2M5ZDI4ZmZkYWI3ZxAFHUZyYW5jZXMgSGF6ZWwgUmVpZCBFbGVtZW50YXJ5BSQ0OTI1YTM4ZC0zN2JjLTQ5MTAtYTk1Yi00NDU4Yjk0YjAyMjhnEAUdRnJlZGVyaWNrIERvdWdsYXNzIEVsZW1lbnRhcnkFJDBhZjFhOGUwLWMzOGYtNGQ3MS04NWI3LWU4ZmE4YmRlZGE1ZmcQBQxGcmVlZG9tIEhpZ2gFJDI5OTVjMTk0LTQ5OWMtNDdlNy05NzlkLWRjZDU0YmI1OGQwZmcQBRNHdWlsZm9yZCBFbGVtZW50YXJ5BSQ5YzVjNTIyYy0xMzg5LTRkYTAtOGJlZS1kMWI3MjgzNmJkZThnEAUTSGFtaWx0b24gRWxlbWVudGFyeQUkZWVmMGEzMWEtYjlhZi00ZmUwLWIzN2QtZWY5NWQ3ZjgyOWY4ZxAFDkhhcm1vbnkgTWlkZGxlBSRkMzQ4MjY1NS1mNTM0LTRhOWMtOTI5MS05NmE3ZThmMzJlNWZnEAUSSGFycGVyIFBhcmsgTWlkZGxlBSQ2Yjk2Y2FhYS01YmFkLTRiODYtYjQxZi04MjRlNWU1NDljMjhnEAUNSGVyaXRhZ2UgSGlnaAUkMzFkNGRmODUtNGFlYS00OWE5LWJmNmEtNDk4NmUxYzIzNzA4ZxAFFEhpbGxzYm9ybyBFbGVtZW50YXJ5BSQ5Y2JlYjlhNi0yZmQyLTQ0NWItODg0Ny02MTg3MzdjYmU0YjBnEAUTSGlsbHNpZGUgRWxlbWVudGFyeQUkODY2NTQ4Y2MtNDNjMC00OWZlLThlZDQtYTBjNThlZjZjY2Q0ZxAFEkhvcml6b24gRWxlbWVudGFyeQUkODkyOWJlYjktZGMwZi00ZTc3LTg4NWItZjI1NzY1Y2UyMmRlZxAFGUh1dGNoaXNvbiBGYXJtIEVsZW1lbnRhcnkFJDJhMGZhN2Y2LTIxZjctNDE0Zi04ODZmLTAwZjY2NmQ2ZGEzOGcQBRRKLiBMLiBTaW1wc29uIE1pZGRsZQUkNTY3MzMyY2QtNWZlMy00MmI4LTliZDgtMWY0NmVhMDRiZDNhZxAFGkouIE1pY2hhZWwgTHVuc2ZvcmQgTWlkZGxlBSQyNjk1MDYwOS00MjdiLTQ3NTYtYTIxNy1iMWQ2N2Q3MTdmNDNnEAUQSm9obiBDaGFtcGUgSGlnaAUkNmIxZmFlMTQtMDYyZC00Nzc2LWI4MGQtNzM2ZDA0ZDc2ZjNhZxAFHkpvaG4gVy4gVG9sYmVydCBKci4gRWxlbWVudGFyeQUkZDViMzgwN2QtNTExMy00YTI0LWJkOGQtZWQwYzcxODg0NzZkZxAFHUtlbm5ldGggVy4gQ3VsYmVydCBFbGVtZW50YXJ5BSRlODlmYWIyNy0wMjBjLTQzMjctYWFjNi1iNTA3ODU1MDkwNjJnEAUZTENQUyBIaWdoIFNjaG9vbCBUcmFpbmluZwUkMjYyN2I5OTUtNmYzMi00ZTMxLWJlMTAtMGViM2NhOGRmY2MyZxAFB0xDUFMgSFMFJDE5MWFiYTMxLWI3NGYtNDZhNy1hZDc4LTVjMDczYzFkOWNmMmcQBRtMQ1BTIE1pZGRsZSBTY2hvb2wgVHJhaW5pbmcFJDI4YmQwMTczLTVlYjMtNGI4OC04MWFiLWU1N2I5OTc3N2NkM2cQBQdMQ1BTIE1TBSRjZThlNzhmYy03MGNkLTQ1YWItYTk5Ny1jN2FhNWNlMjJkNThnEAUTTGVlc2J1cmcgRWxlbWVudGFyeQUkMDM2YmI5NmUtNzY4OS00NTQzLWE1MGMtNGNmZDAxMjc3NWE1ZxAFEUxlZ2FjeSBFbGVtZW50YXJ5BSRlOGZkYjg3Zi03ZjNiLTQ1YjUtOWFkNS1kMzVmNTVlNjE5MjJnEAUSTGliZXJ0eSBFbGVtZW50YXJ5BSQ4YmYwN2FkNy02Yzg3LTQxYWItODNjYS03ZGFmYTBhYzgyZTVnEAUSTGluY29sbiBFbGVtZW50YXJ5BSQ4MzBhMGIzNS1iZTJkLTQxZWYtYjkzNS1iZmI0ZjQwZjVkNDZnEAUXTGl0dGxlIFJpdmVyIEVsZW1lbnRhcnkFJDlhNGNjZGFhLTYyZmEtNDBmNS05YjFkLWUzNmIzN2JjMjI2MGcQBRNMb3Vkb3VuIENvdW50eSBIaWdoBSQ2MzM1OTlhZi1mMjM2LTRjZGQtYmJiYS04ZDlhMTI5OTFhOTNnEAUmTG91ZG91biBDb3VudHkgUHVibGljIFNjaG9vbHMgVHJhaW5pbmcFJDk1ZDE2YWZmLWMyYTktNDI1ZC04YTc2LWVmMTJmMWU2NDIxNmcQBRNMb3Vkb3VuIFZhbGxleSBIaWdoBSRhMjM2YjVjYS05Nzk1LTRhZTAtOTViMS0zMDZkMTYxOWJhZmZnEAUXTG92ZXR0c3ZpbGxlIEVsZW1lbnRhcnkFJGI4NDNhYmIzLTRlNTItNDZjMS05ZWI4LTRmMjYxMzJiZGVlMGcQBRdMb3dlcyBJc2xhbmQgRWxlbWVudGFyeQUkNWQ3NjIxNTktOGRhMS00OWNkLThmOGYtYmQ5YTM1NDBlYjFhZxAFE0x1Y2tldHRzIEVsZW1lbnRhcnkFJDFkZWRlZGM4LWQzOTgtNDRhYi04Y2ViLTA2Y2IxZDA3NTczZmcQBRVNZWFkb3dsYW5kIEVsZW1lbnRhcnkFJDdhY2FjZGQ0LWFmODItNGZkMS1hOTNhLTA1OGFiMTFjM2ZhMmcQBQ1NZXJjZXIgTWlkZGxlBSQyYWE5YWVmZC1jMDQyLTQxODgtOGViNS0yY2M2MDU2OTk0ZjZnEAUVTWlkZGxlYnVyZyBFbGVtZW50YXJ5BSRhMzJmMDQyMi01MDdhLTQzZmItYTRlOS0zOWQ1ODA5MzVlZWVnEAUTTWlsbCBSdW4gRWxlbWVudGFyeQUkODU0YTE0OTgtNzIyMC00ZDdlLTk5MzMtZDBmYmJjM2YzMmFiZxAFGE1vbnJvZSBUZWNobm9sb2d5IENlbnRlcgUkNTZiOTg1OTMtMmVmMy00MmRhLWFjZGYtMmYxZTk1ODNjYzRlZxAFGE1vdW50YWluIFZpZXcgRWxlbWVudGFyeQUkODFmYWM2ZWEtYzMyOC00ZmM0LWIyNzUtNmEzZWEzMjg5MjE2ZxAFFU5ld3Rvbi1MZWUgRWxlbWVudGFyeQUkNTcwY2I4YWQtYmM3MC00NDJkLWFiNTMtMTcwYTcyNTc1NmM2ZxAFDlBhcmsgVmlldyBIaWdoBSRjMzZmNjc2YS0wOTA0LTQxYmItYmE3Yi1hM2M1YjAxZGNkNDZnEAUUUGluZWJyb29rIEVsZW1lbnRhcnkFJGYyNjQ0Y2VhLTYyZWItNDIzMy1hOTJmLTVhMzY3ODM1ZWNmMGcQBRJQb3RvbWFjIEZhbGxzIEhpZ2gFJDI4ZGM2MWM0LWY2YjMtNDU5OS05NTdkLWViZGRjZDY2NzE1N2cQBRRQb3Rvd21hY2sgRWxlbWVudGFyeQUkYWZlYmFmNDAtYjcwNC00ZTEwLWFhMjMtZWZjMWNiNDU3YTFjZxAFEVJpdmVyIEJlbmQgTWlkZGxlBSQwZjE1MWJiMi0wMTdhLTQzNzEtOGYyNS01M2MyOTNkNzBjOGVnEAUYUm9sbGluZyBSaWRnZSBFbGVtZW50YXJ5BSQ3N2U4MTYxOC1jN2MxLTQ4YWItYWQ3MS1mNDRhNDczMGI5YjRnEAUaUm9zYSBMZWUgQ2FydGVyIEVsZW1lbnRhcnkFJDJmZDExYjAyLTJlZWMtNDFlOC1hNDU0LTUzODQxNGE4OTU4MGcQBRVSb3VuZCBIaWxsIEVsZW1lbnRhcnkFJDYyNGRkNDgzLWY2Y2UtNGM3Ni04ZWFmLWY1NTFiNDMwMWM2OWcQBRlTYW5kZXJzIENvcm5lciBFbGVtZW50YXJ5BSQ5M2Y0MWFhOS00YTEwLTQ3MmYtYWU2ZC02NDIxOTc0YTBlNjNnEAUYU2Vjb25kYXJ5IFRlc3RpbmcgU2Nob29sBSRmODg1OTMwOS1hOTEwLTRhNDEtODc5NC1iODVmMzM2NWM2MGRnEAUaU2VsZGVucyBMYW5kaW5nIEVsZW1lbnRhcnkFJGMyYmMxYTY5LTUwNjEtNGNkZC1hOWJiLTBiZDYzYmU3YzMyZGcQBRNTZW5lY2EgUmlkZ2UgTWlkZGxlBSRjZjlmZDkzMi04ZjA3LTQ2NWEtYjVmNy1kOWZmODU5YzJmMGRnEAUTU21hcnQncyBNaWxsIE1pZGRsZQUkYjAxNTI3ZmYtYmQwNy00Mjc3LThjZjAtZDFkODM4ZTc1YWQyZxAFE1N0ZXJsaW5nIEVsZW1lbnRhcnkFJDlhNTFmNmU3LWU2ZDItNDliNi1iYWI2LWM3YjNjNjViYzZmY2cQBQ9TdGVybGluZyBNaWRkbGUFJGZiODk5ZjYzLWEwMjItNGNhNi05MjhjLTM2OGM4OWZhNTVmYmcQBRxTdGV1YXJ0IFcuIFdlbGxlciBFbGVtZW50YXJ5BSQ4N2EyM2NjYy0zMjM4LTRiMWItOTc1MS04OWYwNDg3ZjcyZDVnEAURU3RvbmUgQnJpZGdlIEhpZ2gFJDlmYjlhYjg4LTgxYWQtNDk0My1hZGNlLWQyYWNhZTY4NDAyMWcQBRFTdG9uZSBIaWxsIE1pZGRsZQUkYTgzMDQ2N2MtYzc0Ny00OWIxLWFhZTYtZjYyYWRiNDQ3OTNhZxAFFFN1Z2FybGFuZCBFbGVtZW50YXJ5BSQ5MWQ2YWQ1MS0yNDk4LTQ5YTMtYTg2NC01MTUwN2M2NWQ1MmFnEAUQU3VsbHkgRWxlbWVudGFyeQUkODEzMWQ2YzEtMjU2YS00NDIxLTg2ZWQtZjNhMWI5ZTE3NTI3ZxAFElN1bW1lciBTY2hvb2wgSFMtMgUkNWVlMmY0YTktNmY3Zi00MDQ1LWJiMzgtMDYwOWRjZWUyYjIwZxAFElN1bW1lciBTY2hvb2wgSFMtMwUkNjlkMzNlOTItYmJlZi00NTY4LWE4NzItNGFmNjhjMWIzMzIyZxAFElN1bW1lciBTY2hvb2wgTVMtMQUkNzkwMDI4NWUtYWM5OS00MTE4LTkwZDAtNzVmYTA1YzU2YzJhZxAFGFN5Y29saW4gQ3JlZWsgRWxlbWVudGFyeQUkZDc2MjM3NGEtZTNlYS00MDUzLTljYWEtNzdlOTQ3YzhlMWI2ZxAFClRTVCBTY2hvb2wFJDA1NTI1NmMxLWE4ZDgtNGE3Mi1hYTJiLTQ4Nzg0ZThlYjQwNWcQBRVUdXNjYXJvcmEgSGlnaCBTY2hvb2wFJDhjNDExODRmLTgyYjItNDM5OC04NWNjLTIxZWY0NzVkMGM3ZmcQBRRXYXRlcmZvcmQgRWxlbWVudGFyeQUkMWE3Mzk2NjYtYTc0My00NWZiLWI1NmItNDJkNTEyM2ZlNTBmZxAFDldvb2Rncm92ZSBIaWdoBSQ0ZGZkM2E0My01N2ZlLTRkOTgtYjUzMC05ODZhNDBlODE0MDVnZGRk+62FnolMiBYRJtqogd5k79gh1bo="

#define EVENTVALIDATION @"/wEWYQLe1LadDgK88dn+DQL9lcKZDAK1sZ+YBQLhqcTXDwKAgsOUBwKgofaJCQKo+NDFDgKM9JPfCQLTuveVCgL0iv7tBwKLkeqfCQK/g6GTBgKMvI+2CwKGzYLUAQKl8bO1AQKUwsKWBgLD762GDwLY992TCwKaq7DyBgLT2pDuDgKtmZfZCgKFsuKKCALg4JW+DgK++LLwDgLkgI1+Ar/EwZwPAvfJ+OAOAtvoreEIAvu+yZ4PArSAgd0IAtOe1owBAsTonIADAuGp1ZAJAqqBrIQIAsHrgeINArbG/54CAriunc8FArzqr+4FApbzgPEGAqbij98EAvr01r4DAri+r8kMAovd4HECq9O2jA0C14/6wgMC8K/jrQMC97ubqgICv7ny/gQCv77bgQMC4d++rgwCtbeyuAgC2sjXqwwC9bGs7g0Cx6CP6A0ClI3puwoCx7XMgA4CgtKHlwQCkOq0xgsCmvyt1QMClcu8cALQ2KWAAgKdh4uiCwKiroGDBALl8Lq8AgK+n8C3BgKekanjAgL7r7aFDAK1udSUDAL/79jkCQLkytziBQLeneX1DQL+wqOjCAK7/pjZAwLV7JfRBwKrmo6yCgLGm8/HCwLZlevtDQKZ36b1DwLwqsH8BQKX6bOgDwKa1IS8BAKxuZWfCAKdzKa6AwKc34SKCAKbqb2lBAKPh+GnAgKwwfbhCgK33uHXDQLYq5CkDAL+qJKbBALcpPMCArbi+dIKAsiLoa4HArT6kL0GAqqDz9gCAvrN0fQCG2aa8Qmhek4WBVwzZ+u+paNtRrc="

@interface LoginProcessor ()

- (NSString *) getUsername;
- (NSDictionary *) getClassData:(NSNumber *)count;
- (NSArray *) getGradeData;

@end

@implementation LoginProcessor

@synthesize password = _password;
@synthesize username = _login;
@synthesize school = _school;
@synthesize autologin = _autologin;

- (id) init
{
    if (self = [super init])
    {
    }
    self.classData = [[NSMutableDictionary alloc]init];
    self.quarter = -1;
    NSLog(@"INIT");
    return self;
}


- (NSString *) getUsername
{
    return [self username];
}


- (Boolean) login
{
    NSLog(@"LOGGIN IN");
    NSURL *url = [[NSURL alloc]initWithString:@"https://loudoun.gradebook.net/Pinnacle/PIV/Logon.aspx"];
    NSMutableString *cookie = [NSMutableString stringWithFormat:@"InternetViewer.SchoolId=%@",self.school];
    NSMutableDictionary *requestHeaders = [[NSMutableDictionary alloc]init];

    [requestHeaders setObject:UA forKey:@"User-Agent"];
    [requestHeaders setObject:cookie forKey:@"Cookie"];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    request.requestHeaders = requestHeaders;

    [request setRequestMethod:@"POST"];
    [request setShouldAttemptPersistentConnection:YES];

    [request addPostValue:VIEWSTATE forKey:@"__VIEWSTATE"];
    [request addPostValue:EVENTVALIDATION forKey:@"__EVENTVALIDATION"];
    [request addPostValue:self.username forKey:@"uxStudentId"];
    [request addPostValue:self.password forKey:@"uxPassword"];
    [request addPostValue:self.school forKey:@"uxSchools"];
    [request addPostValue:@"Logon" forKey:@"uxLogon"];
    [request startSynchronous];

    NSString *html = [request responseString];

    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];

    NSArray *schoolElements = [xpath searchWithXPathQuery:@"//*[@id='LearningPlanItem']/a/@href"];

    if ([schoolElements lastObject] == nil)
    {
        return FALSE;
    }
    else
    {
    NSString *dataURL = [[schoolElements[0] firstChild] content];     //gives us url with everything we need
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [dataURL componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];

        [queryStringDictionary setObject:value forKey:key];
    }

    self.authKey = [queryStringDictionary objectForKey:@"authToken"];

    url = [[NSURL alloc]initWithString:@"https://loudoun.gradebook.net/Pinnacle/PIV/UpcomingAssignments.aspx"];
    cookie = [NSMutableString stringWithFormat:@"InternetViewer.SchoolId=%@;%@",self.school,self.AuthKey];
    [requestHeaders setObject:cookie forKey:@"Cookie"];

    request = [ASIFormDataRequest requestWithURL:url];
    request.requestHeaders = requestHeaders;

    [request startSynchronous];

    NSString *lol = [request responseString];

    //NSLog(@"%@",lol);
    self.responseString = lol;
    self.loggedIn = TRUE;
        
    return TRUE;
    }
}


- (NSArray *) getGradeData:(NSString *)data
{
    NSMutableArray *classDataArray = [NSMutableArray array];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:[data dataUsingEncoding:NSUTF8StringEncoding]];

    int classNum = 1;
    int quarterFinder = 0;
    NSMutableString *path = [NSMutableString stringWithFormat:@"//*[@class ='semesterGrades']/tbody/tr[%i]",classNum];
    NSArray *classData = [xpath searchWithXPathQuery:path];
    bool secondTime = false;
    while ([[xpath searchWithXPathQuery:path]lastObject] != nil)
    {
        classData = [xpath searchWithXPathQuery:path];
        NSString *className = [[[[classData[0] children][0] children][0] firstChild] content];
        NSMutableArray *gradesArray = [NSMutableArray array];
        int gradeValueTick = 1;
        NSMutableArray *urlDataArray = [NSMutableArray array];
        while ([[classData[0] children] count] > gradeValueTick)
        {
            NSString *gradeNumber = [[[[[classData[0] children][gradeValueTick] firstChild]children]lastObject]content];
            NSString *gradeURL = [[[classData[0] children][gradeValueTick] firstChild]objectForKey:@"href"];

            if (gradeNumber == nil)
            {
                gradeNumber = [[[classData[0] children][gradeValueTick] firstChild]content];
                if (gradeNumber == nil)
                    gradeNumber = @"N/A";
				else
				{	NSString* gradeLetter = [[[classData[0] children][gradeValueTick+2] firstChild]content];
					gradeNumber = [NSString stringWithFormat:@"%@(%@)",gradeNumber,gradeLetter];
				}
                gradeURL = @"-1";
            }
			else
			{
				NSString* gradeLetter = [[[[[classData[0] children][gradeValueTick+2] firstChild]children]lastObject]content];
				gradeNumber = [NSString stringWithFormat:@"%@(%@)",gradeNumber,gradeLetter];
				
				if(quarterFinder < gradeValueTick)
					quarterFinder = gradeValueTick;
			}

            
            [gradesArray addObject:gradeNumber];
            [urlDataArray addObject:gradeURL];
            gradeValueTick += 3;
        }
        [classDataArray addObject:@[className,gradesArray,urlDataArray]];
        path = [NSMutableString stringWithFormat:@"//*[@class ='semesterGrades']/tbody/tr[%i]",classNum+1];
        if([[xpath searchWithXPathQuery:path]lastObject] == nil && !secondTime)
        {   classNum=0;
            NSLog(@"LOLOLOLOL AA");
            secondTime = true;
        }
        if(!secondTime)
            path = [NSMutableString stringWithFormat:@"//*[@class ='semesterGrades']/tbody/tr[%i]",++classNum];
        else
            path = [NSMutableString stringWithFormat:@"/html/body/table[3]/tbody/tr[%i]",++classNum];
    }
    
    if(self.quarter == -1)
    {
       self.quarter = (quarterFinder-1)/3;
    }
    NSLog(@"QUARTER = %d",self.quarter);
    self.gradeData = classDataArray;
    self.periodString = [self setDefaultString];
    return classDataArray;
}

-(NSString *)setDefaultString
{
    int amountOfPeriods = [self.gradeData[0][1] count];
    NSLog(@"THE PERIODS IS %d",amountOfPeriods);
    if(amountOfPeriods == 6)
    {
        NSArray *sixPeriods = [[NSArray alloc]initWithObjects:@"First Quarter",@"Second Quarter",@"Semester Exams",@"Third Quarter",@"Fourth Quarter",@"Final Exams", nil];

        return [sixPeriods objectAtIndex:self.quarter];
    }
    else if (amountOfPeriods == 9)
    {
        NSArray *ninePeriods = [[NSArray alloc]initWithObjects:@"First Quarter",@"Second Quarter",@"Semester Exams",@"Semester Grades",@"Third Quarter",@"Fourth Quarter",@"Final Exams",@"Second Semester Grades",@"Final Grades", nil];
        
        return [ninePeriods objectAtIndex:self.quarter];
    }
    else if (amountOfPeriods == 4)
    {
        NSArray *fourPeriods = [[NSArray alloc]initWithObjects:@"First Quarter",@"Second Quarter",@"Third Quarter",@"Fourth Quarter", nil];
        return [fourPeriods objectAtIndex:self.quarter];
    }
    else return @"GRADE/SCHOOL NOT IMPLEMENTED";
    
}

- (NSDictionary *) getClassData:(NSNumber *)countNumber
{
    
    int count = [countNumber intValue];
    NSMutableArray *individualClassData = [[NSMutableArray alloc]init];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://loudoun.gradebook.net/Pinnacle/PIV/%@",self.gradeData[count][2][self.quarter]];
    NSLog(@"%@",urlString);
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSMutableString *cookie = [NSMutableString stringWithFormat:@"InternetViewer.SchoolId=%@;%@",self.school,self.AuthKey];
    NSMutableDictionary *requestHeaders = [[NSMutableDictionary alloc]init];
    [requestHeaders setObject:UA forKey:@"User-Agent"];
    [requestHeaders setObject:cookie forKey:@"Cookie"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestHeaders = requestHeaders;

    [request startSynchronous];
 
    int gradeNum = 1;
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableString *path = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]",gradeNum];

    if([request responseStatusCode] == 400 || [request responseStatusCode] == 401)
    {
        NSLog(@"[request responseStatusCode] == %d",[request responseStatusCode]);
        [self login];
        [self getClassData:countNumber];
    }
    NSLog(@"[request responseStatusCode] == %d",[request responseStatusCode]);
  
    
    while ([[xpath searchWithXPathQuery:path]lastObject] != nil)
    {

        NSString *gradeNumberScore = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]/td[4]",gradeNum];
        NSString *gradeNumberTotal = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]/td[5]",gradeNum];
        
        NSString *gradeLetter = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]/td[6]",gradeNum];
        
        NSString *gradeName = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]/td[1]/a",gradeNum];
        
        path = [NSMutableString stringWithFormat:@"//*[@id='Assignments']/tbody/tr[%i]",++gradeNum];
        

        //NSLog(@"%@==%@/%@",[[[xpath searchWithXPathQuery:gradeName][0] firstChild] content],[[[xpath searchWithXPathQuery:gradeNumberScore][0] firstChild] content],[[[xpath searchWithXPathQuery:gradeNumberTotal][0] firstChild] content]);
        
        gradeNumberScore = [[[xpath searchWithXPathQuery:gradeNumberScore][0] firstChild] content];
        if(gradeNumberScore == nil)
        {
            NSLog(@"WE GOT A NIL");
            gradeNumberScore = @"N/A";
            gradeNumberTotal = @"";
            gradeLetter = @"";
        }
        else
        {
            gradeNumberTotal = [[[xpath searchWithXPathQuery:gradeNumberTotal][0] firstChild] content];
            gradeLetter = [[[xpath searchWithXPathQuery:gradeLetter][0] firstChild] content];
        }
        
        gradeName = [[[xpath searchWithXPathQuery:gradeName][0] firstChild] content];
        
        
        NSDictionary * dict = @{gradeName:@[gradeNumberScore,gradeNumberTotal,gradeLetter]};
        [individualClassData addObject:dict];
    }
	
    [self.classData setObject:individualClassData forKey:countNumber];

	return self.classData;
}


@end
