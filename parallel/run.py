import joblib
import uuid
import pprint

NUMBER_OF_CALC_TIMES = 1000

def task(num):
    resp = []
    for i in range(num):
        resp.append(uuid.uuid4())

    return resp

def pretty_print(obj):
    pprint.pprint(obj)

if __name__ == '__main__':
    res = joblib.Parallel(n_jobs=-1)([joblib.delayed(task)(num) for num in list(range(NUMBER_OF_CALC_TIMES))])
    # 計算の結果のlistが入っているlistなので、list長はNUMBER_OF_CALC_TIMESと一致する
    print(str(len(res)))
