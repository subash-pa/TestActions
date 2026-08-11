# /// script
# dependencies = [
#       "strands",
#       "strands-agents[openai]"
# ]
# ///
from strands import Agent, tool
from strands.models import OpenAIModel

hosted_model = OpenAIModel(
   model_id='openrouter/free',
   client_args={
      "base_url": "https://openrouter.ai/api/v1",
      "api_key": "s"
      }
)

schema = ''

@tool(name = 'get_db_schema', description = 'Provide the DB schema for script review')
def get_db_schema() -> str:
  global schema
  if schema == None or schema == '':
    with open('schema.sql', 'r') as s:
      schema = s.read()
  return schema
  
@tool(name='db_connection', description = 'DB connection to execute the scripts for script review (note: it is still in under development. So do not use it)')
def dg_connection(query: str) -> str:
  pass
  
agent = Agent(
  model = hosted_model,
  tools=[get_db_schema, dg_connection],
  system_prompt = 'You are an agent to review the SQL script [Oracle]. You just have review the structure, joins, alias and provide the suggestion to modify the script'
)
  
if __name__ == '__main__':
  response = agent(''' review below SQL
   SELECT first_name, last_name, email, street_address, city, provider, masked_card_number, status
   FROM customer, address, payment_info, account_info
   WHERE customer.customer_id = address.customer_id
  AND customer.customer_id = payment_info.customer_id
  AND customer.customer_id = account_info.customer_id
  AND address.is_default = 1
  AND payment_info.is_default = 1
  AND status = 'ACTIVE';'''
  )
  print(response)
  

  
