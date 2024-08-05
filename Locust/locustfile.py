from locust import HttpUser, task, between
import random
import string

class GraphQLUser(HttpUser):
    wait_time = between(1, 2)  # Simulate real user wait time between tasks

    @task
    
    def put_external_query_system(self):
        def generate_random_string(length):
            letters = string.ascii_lowercase
            return ''.join(random.choice(letters) for i in range(length))

        external_system_id = random.randint(1, 10000)  
        external_system_code = f"sys-{random.randint(1, 10000)}"
        external_system_name = generate_random_string(7)
        data_code = external_system_id
        data_descriptor = generate_random_string(15)
        query = f'''
            mutation ExternalSystemSave {{
                externalSystemSave(
                    input: {{
                        externalSystemId: {external_system_id}
                        externalSystemCode: "{external_system_code}"
                        externalSystemName: "{external_system_name}"
                        data: {{ code: {data_code}, descriptor: "{data_descriptor}" }}
                    }}
                ) {{
                    httpStatusCode
                    message
                }}
            }}
        '''
        print(query)
        self.client.post('/graphql', json={'query': query})
    