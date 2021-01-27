SELECT
  email,
  '${String(column).split("|")[1]}' AS name,
  ${String(column).split("|")[0]} AS value,
  '${String(column).split("|")[2]}' AS fieldType,
  '${String(column).split("|")[3]}' AS type,
  ROW_NUMBER() OVER (ORDER BY email) AS row_no
FROM
  common_pd.sgm_hubspot
WHERE
  business_kbn = 'Lifree'
  AND email IS NOT NULL
  AND ${String(column).split("|")[0]} IS NOT NULL
  AND email NOT IN (SELECT email FROM common_pd.error_list)
  -- 全角文字を含むメールアドレスを除外
  AND REGEXP_LIKE(TRIM(email), '[^\x01-\x7E]') = false
  -- ・「@」が1つも含まれていないメールアドレスを除外
  AND REGEXP_LIKE(TRIM(email), '[@]') = true
  -- 行末が".", "/"または数字のメールアドレスを除外
  AND REGEXP_LIKE(TRIM(email), '[\.\/0-9]$') = false