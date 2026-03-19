# Realizați o funcție Python folosind defcare realizează preprocesarea generală a unui dataset pandas.
# Funcția trebuie să trateze automat următoarele aspecte:valori lipsă, duplicate, detectare outlieri (pentru variabile numerice),
#                                                   codarea variabilelor categoriale

# importam librariile 
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder

def preprocesare_generala(df_input):
    # cream o copie ca să nu modificăm originalul direct
    df = df_input.copy()
    
    # tratare duplicitate
    df.drop_duplicates(inplace=True)
    
    # inlocuire valori lipsa 
    for col in df.columns:
        if df[col].dtype in ['float64', 'int64']:
            # pentru cifre: punem media
            df[col] = df[col].fillna(df[col].mean())
        else:
            # pentru text/categorii: punem valoarea cea mai frecventă (Modus)
            df[col] = df[col].fillna(df[col].mode()[0])
            
    # detectare outliers (folosind metoda IQR - Interquartile Range)
    # outlierii sunt valori mult prea mari sau prea mici 
    for col in df.select_dtypes(include=[np.number]).columns:
        Q1 = df[col].quantile(0.25)
        Q3 = df[col].quantile(0.75)
        IQR = Q3 - Q1
        limita_inf = Q1 - 1.5 * IQR
        limita_sup = Q3 + 1.5 * IQR
        # eliminăm rândurile care depășesc aceste limite
        df = df[(df[col] >= limita_inf) & (df[col] <= limita_sup)]

    # codarea variabilelor categoriale (Label Encoding)
    # transformam textul in numere pentru ca informatiile sa fie cititte de calculator
    le = LabelEncoder()
    for col in df.select_dtypes(include=['object', 'category']).columns:
        df[col] = le.fit_transform(df[col].astype(str))
        
    return df

df_titanic = pd.read_csv('Titanic.csv')
df_curatat = preprocesare_generala(df_titanic)
print(df_curatat.head())