curl -XGET "http://localhost:9200/library/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {
    }
  }
}'