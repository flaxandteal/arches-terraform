import json
import sys

def zap_to_sarif(zap_report):
    sarif = {
        "version": "2.1.0",
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "runs": [{
            "tool": {
                "driver": {
                    "name": "OWASP ZAP",
                    "informationUri": "https://www.zaproxy.org/",
                    "rules": []
                }
            },
            "results": []
        }]
    }

    rule_ids = set()
    for alert in zap_report.get("site", [{}])[0].get("alerts", []):
        rule_id = alert["pluginId"]
        if rule_id not in rule_ids:
            sarif["runs"][0]["tool"]["driver"]["rules"].append({
                "id": rule_id,
                "name": alert["name"],
                "fullDescription": { "text": alert["description"] }
            })
            rule_ids.add(rule_id)

        sarif["runs"][0]["results"].append({
            "ruleId": rule_id,
            "level": "warning" if alert["riskcode"] in ["1", "2"] else "error",
            "message": { "text": alert["alert"] },
            "locations": [{
                "physicalLocation": {
                    "artifactLocation": { "uri": alert["url"] }
                }
            }]
        })

    return sarif

with open("zap_report.json") as f:
    zap_json = json.load(f)

sarif = zap_to_sarif(zap_json)

with open("zap_report.sarif", "w") as f:
    json.dump(sarif, f, indent=2)
