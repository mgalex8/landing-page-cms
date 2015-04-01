<h2><?php echo $result['title']; ?></h2>
<div class="span12" style="padding:40px">    
    <form action="<?php echo $result['action_url']; ?>" method="post" enctype="multypart/form-data">        
        <table>
            <tr>
                <td class="span2"></td>
                <td><div class="error errors">                        
                        <?php
                            foreach ($result['errors'] as $err)
                            {
                                echo '<div>' . $err . '</div>';
                            }    
                        ?>
                    </div></td>
            </tr>                    
            <tr>
                <td class="span2"><?php echo __('ID'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['item']['name']; ?>" /></td>
            </tr>
            <tr>
                <td class="span2"><?php echo __('Name'); ?>*:</td>
                <td><input type="text" name="name" value="<?php echo $result['item']['name']; ?>" /></td>
            </tr>           
            <tr>
                <td class="span2"><?php echo __('Description'); ?>*:</td>
                <td><input type="text" name="text" value="<?php echo $result['item']['text']; ?>" /></td>                    
            </tr>
            <?php 
                foreach ($result['fields'] as $field): 
            ?>
                    <tr>
                    <td class="span2"><?php echo i18n($field['i18n'], $field['title']; ?><?php if ($field['required'] == 1): ?>*<?php endif; ?>:</td>
            <?php
                    if ($field['type'] == 'text') :
            ?>
                        <td><input type="text" name="field[<?php echo $field['name']; ?>]" value="<?php echo $result['field_values'][$field['name']]; ?>" /></td>
            <?php 
                    elseif ($field['type'] == 'file') :
            ?>
                        <td><input type="file" name="field[<?php echo $field['name']; ?>]" value="<?php echo $result['field_values'][$field['name']]; ?>" /></td>
            <?php 
                    elseif ($field['type'] == 'hidden') :
            ?>
                        <td><input type="hidden" name="field[<?php echo $field['name']; ?>]" value="<?php echo $result['field_values'][$field['name']]; ?>" /></td>
            <?php 
                    elseif ($field['type'] == 'checkbox') :
            ?>
                        <td><input type="chackbox" name="field[<?php echo $field['name']; ?>]"<?php if($result['field_values'][$field['name']] == 'on'): ?> checked<?php endif; ?> /></td>
            <?php 
                    elseif ($field['type'] == 'textarea') :
            ?>
                        <td><textarea name="field[<?php echo $field['name']; ?>]"><?php echo $result['field_values'][$field['name']]; ?></textarea></td>
            <?php 
                    elseif ($field['type'] == 'select') :
            ?>
                        <td><select name="field[<?php echo $field['name']; ?>]">
                        </select></td>
            <?php 
                    endif; 
            ?>
                    </tr>
            <?php
                endforeach; 
            ?>
            <tr>
                <td class="span2" colspan="2">&nbsp</td>
            </tr>
            <tr>
                <td class="span2"></td>
                <td><input type="submit" class="btn btn-success" value="<?php echo $result['title']; ?>" /></td>
            </tr>
        </table>          
    </form>
<div>